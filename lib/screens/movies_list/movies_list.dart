import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/apis.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_details_screen_lazyload.dart';
import 'package:imdb_bloc/screens/movies_list/cubit/content_type_cubit.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../apis/get_movie_content_type.dart';
import '../../apis/user_lists.dart';
import '../../beans/details.dart';
import '../../beans/list_resp.dart';
import '../../beans/new_list_result_resp.dart';
import '../../constants/colors_constants.dart';
import '../../constants/config_constants.dart';
import '../../cubit/filter_button_cubit.dart';
import '../../utils/platform.dart';
import '../../widgets/filter_buttons.dart';
import '../../widgets/movie_poster_card.dart';
import '../person/person_detail_screen.dart';
import '../user_profile/utils/you_screen_utils.dart';

class MoviesListScreenData {
  final String title;
  final bool showFilters;
  final ListResult? listResult;
  final NewMovieListRespResult newMovieListRespResult;
  final Function()? onScrollEnd;

  MoviesListScreenData(
      {this.listResult,
      required this.title,
      required this.newMovieListRespResult,
      this.showFilters = true,
      this.onScrollEnd});
}

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({
    super.key,
    required this.data,
  });
  final MoviesListScreenData data;
  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  final _typesMap = <String?, String>{};
  Future<void> getContentTypes() async {
    var movieDetailsResp = await getMoviesTypeApi(widget
            .data.newMovieListRespResult.movies
            ?.map((e) => e?.id ?? '')
            .toList() ??
        []);
    for (var element in movieDetailsResp?.result ?? <MovieBean>[]) {
      _typesMap[element.id] = element.contentType ?? '';
    }
  }

  bool filterList(MovieOfList? movie, BuildContext context) {
    if (movie == null) {
      return false;
    }
    return filtered(context.read<FilterButtonCubit>().state, movie);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _enablePullUp = true;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => FilterButtonCubit())),
        BlocProvider(create: ((context) {
          var contentTypeCubit = ContentTypeCubit();
          getContentTypes().then((value) {
            if (mounted) {
              contentTypeCubit.setState(ContentTypeNormal());
            }
          });
          return contentTypeCubit;
        })),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      '${widget.data.title} ',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  // AutoSizeText(cnt)
                ],
              ),
            ),
            body: BlocBuilder<FilterButtonCubit, FilterButtonState>(
              builder: (context, state) {
                var filteredMovies = _filteredMovies(context);

                return SmartRefresher(
                  controller: _refreshController,
                  scrollController: _scrollController,
                  enablePullUp: _enablePullUp,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    _refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    dp('${widget.data.newMovieListRespResult.movies?.length} ${widget.data.newMovieListRespResult.count} ${widget.data.newMovieListRespResult.next}');

                    if ((widget.data.newMovieListRespResult.movies?.length ??
                            0) <
                        (widget.data.newMovieListRespResult.count ?? 0)) {
                      if (widget.data.newMovieListRespResult.next != null) {
                        dp('widget.data.newMovieListRespResult.next!=null');
                        var newMovieListRespResult =
                            await getListResultByHrefApi(
                                widget.data.newMovieListRespResult.next!);
                        widget.data.newMovieListRespResult.movies?.addAll(
                            newMovieListRespResult?.movies ?? <MovieOfList?>[]);
                        widget.data.newMovieListRespResult.next =
                            newMovieListRespResult?.next;
                        getContentTypes().then((value) {
                          context
                              .read<ContentTypeCubit>()
                              .setState(ContentTypeNormal());
                          dp('_typesMap=$_typesMap');
                        });
                      }
                    }
                    if (widget.data.onScrollEnd != null) {
                      await widget.data.onScrollEnd!();
                    }
                    if (widget.data.newMovieListRespResult.movies?.length ==
                        widget.data.newMovieListRespResult.count) {
                      _enablePullUp = false;
                    }
                    // if (widget.data.newMovieListRespResult.next == null) {
                    //   widget.data.newMovieListRespResult.count =
                    //       widget.data.newMovieListRespResult.movies?.length;
                    //   dp('widget.data.newMovieListRespResult.count =${widget.data.newMovieListRespResult.count}');
                    //   _enablePullUp = false;
                    // }

                    if (mounted) {
                      setState(() {});
                    }
                    _refreshController.loadComplete();
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      if (widget.data.showFilters)
                        SliverAppBar(
                          forceElevated: true,
                          floating: true,
                          expandedHeight: 80,
                          leading: const SizedBox(),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: NotificationListener<
                                      ScrollEndNotification>(
                                    onNotification: (note) {
                                      //防止FilterButtons的scroll被上层的NotificationListener监听到
                                      return true;
                                    },
                                    child: BlocBuilder<ContentTypeCubit,
                                        ContentTypeState>(
                                      builder: (context, state) {
                                        return FilterButtons(
                                          tag: '',
                                          btnNames: [
                                            if (state is ContentTypeNormal)
                                              BtnNames.type,
                                            BtnNames.genres,
                                            BtnNames.runtime,
                                            BtnNames.rate,
                                          ],
                                          options: {
                                            if (_typesMap.values.isNotEmpty)
                                              BtnNames.type: _typesMap.values
                                                  .toSet()
                                                  .toList(),
                                            BtnNames.genres: widget
                                                    .data
                                                    .newMovieListRespResult
                                                    .movies
                                                    ?.map((e) =>
                                                        (e?.genres ?? 'Other')
                                                            .split(', '))
                                                    .expand(
                                                        (element) => element)
                                                    .toSet()
                                                    .toList() ??
                                                []
                                          },
                                          onFilterChanged: () {},
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                    '${filteredMovies.length} of ${widget.data.newMovieListRespResult.count ?? 0} titles')
                              ],
                            ),
                          ),
                        ),
                      // else
                      //   SliverAppBar(
                      //     expandedHeight: 100,
                      //     leading: const SizedBox(),
                      //     floating: true,
                      //     flexibleSpace: FlexibleSpaceBar(
                      //         stretchModes: const [StretchMode.blurBackground],
                      //         // expandedTitleScale: 2.0,
                      //         // padding: const EdgeInsets.all(8.0),
                      //         // color: Theme.of(context).cardColor,
                      //         background: Material(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Text(widget.data.title),
                      //                 Row(
                      //                   children: [
                      //                     const Text(
                      //                       'A list of //todo titles',
                      //                       style:
                      //                           TextStyle(color: Colors.grey),
                      //                     ),
                      //                     InkWell(
                      //                       onTap: () {
                      //                         var authorId = widget
                      //                             .data.listResult?.authorId;
                      //                         if (!isBlank(authorId)) {
                      //                           //todo
                      //                           // Get.to(() =>
                      //                           //     ImdbUserInfoScreen(uid: authorId!));
                      //                         }
                      //                       },
                      //                       child: Text(
                      //                         ' //todo _authorInfo',
                      //                         style: TextStyle(
                      //                             color: Colors.blue[200]),
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         )),
                      //   ),

                      if (PlatformUtils.screenAspectRatio(context) > 1)
                        SliverGrid(
                            delegate: _delegate(context, filteredMovies),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  PlatformUtils.gridCrossAxisCount(context),
                            ))
                      else
                        SliverList(
                            delegate: _delegate(context, filteredMovies)),
                      if (!_enablePullUp)
                        const SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'You have reached the end of the list',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ));
      }),
    );
  }

  SliverChildBuilderDelegate _delegate(
      BuildContext context, List<MovieOfList?> filteredMovies) {
    const height = 180.0;
    return SliverChildBuilderDelegate((context, index) {
      if (filteredMovies.isEmpty) {
        return const SizedBox();
      }
      var movie = filteredMovies[index];

      return SizedBox(
        // height: movie != null && filterList(movie, context) ? null : 0,
        child: movie != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.data.listResult?.authorId ==
                            context.read<UserCubit>().state.username)
                          InkWell(
                            onTap: () async {
                              await deleteIdFromList(movie.id,
                                  widget.data.listResult?.listUrl, context, () {
                                widget.data.newMovieListRespResult.movies!
                                    .removeAt(index);
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                                  authorId:
                                      widget.data.listResult?.authorId ?? '');
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.more_horiz),
                            ),
                          )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pushRoute(
                          context: context,
                          screen: MovieFullDetailScreenLazyLoad(mid: movie.id));
                    },
                    child: SizedBox(
                      height: height,
                      child: Row(
                        children: [
                          SizedBox(
                            height: height * 0.8,
                            child: PosterWithOutTitle(
                                posterUrl: movie.cover ?? defaultCover,
                                id: movie.id),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  if (movie.userRate != null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                        Text('${movie.userRate}')
                                      ],
                                    ),
                                  SizedBox(
                                    // width: screenWidth(context) * 0.2,
                                    child: AutoSizeText(
                                      '${movie.title}',
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: imdbYellow,
                                      ),
                                      Text('${movie.rate}'),
                                      Text(
                                          '${movie.yearRange} ${movie.runtime}min'),
                                    ],
                                  ),
                                  Text('${movie.genres}'),
                                  StarsOrDirector(
                                      names: movie.director ?? [],
                                      type: 'Director'),
                                  StarsOrDirector(
                                    names: movie.stars ?? [],
                                    type: 'Star',
                                  ),

                                  AutoSizeText(
                                    '${movie.intro}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // if (!PlatformUtils.isDesktop) const Divider()
                ],
              )
            : const SizedBox(
                // height: 0,
                ),
      );
    }, childCount: filteredMovies.length);
  }

  List<MovieOfList?> _filteredMovies(BuildContext context) {
    var list = widget.data.newMovieListRespResult.movies
            ?.where((element) => filterList(
                element?..contentType = _typesMap[element.id], context))
            .toList() ??
        [];
    return list;
  }
}

class StarsOrDirector extends StatelessWidget {
  const StarsOrDirector({
    Key? key,
    required this.names,
    required this.type,
  }) : super(key: key);
  final String type;
  final List<NameId> names;

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) {
      return const SizedBox();
    }
    var suffix = names.length > 1 ? 's' : '';
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$type$suffix: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollEndNotification>(
              //屏蔽ScrollEndNotification
              onNotification: ((notification) => true),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Text(' / '),
                scrollDirection: Axis.horizontal,
                itemCount: names.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        pushRoute(
                            context: context,
                            screen: PersonDetailScreen(pid: names[index].id));
                      },
                      child: Text(
                        '${names[index].name}',
                        style: const TextStyle(color: Colors.blue),
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatefulWidget {
  const MovieCard(
      {super.key,
      required this.movie,
      required this.data,
      required this.index});
  final MovieOfList movie;
  final MoviesListScreenData data;
  final int index;
  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with AutomaticKeepAliveClientMixin {
  late Future<String?> _future;
  @override
  void initState() {
    _future = getData();
    super.initState();
  }

  Future<String?> getData() async {
    dp('55555555555555555555555555555555');
    var movieDetailsResp =
        // await flutterCompute(getMoviesTypeApi, [widget.movie.id]);
        await getMoviesTypeApi([widget.movie.id]);
    dp('666');

    if (movieDetailsResp?.result?.isNotEmpty != true) {
      return null;
    }
    return movieDetailsResp?.result?.first.contentType;
  }

  @override
  void didUpdateWidget(covariant MovieCard oldWidget) {
    _future = getData();
    super.didUpdateWidget(oldWidget);
  }

  final height = 185.0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final movie = widget.movie;
    final index = widget.index;
    dp('_MovieCardState build');
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: height,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          dp("777777777777777777${snapshot.data}");
          if ((context
                      .read<FilterButtonCubit>()
                      .state
                      .filters[btnDisplayName(BtnNames.type)] ==
                  null /*such filter does not exist*/ || /*filter exists and value matches*/
              context
                      .read<FilterButtonCubit>()
                      .state
                      .filters[btnDisplayName(BtnNames.type)]!
                      .toLowerCase() ==
                  snapshot.data?.toLowerCase())) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.data.listResult?.authorId ==
                          context.read<UserCubit>().state.username)
                        InkWell(
                          onTap: () async {
                            await deleteIdFromList(movie.id,
                                widget.data.listResult?.listUrl, context, () {
                              widget.data.newMovieListRespResult.movies!
                                  .removeAt(index);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                                authorId:
                                    widget.data.listResult?.authorId ?? '');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.more_horiz),
                          ),
                        )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    pushRoute(
                        context: context,
                        screen: MovieFullDetailScreenLazyLoad(mid: movie.id));
                  },
                  child: SizedBox(
                    height: height,
                    child: Row(
                      children: [
                        SizedBox(
                          height: height * 0.8,
                          child: PosterWithOutTitle(
                              posterUrl: movie.cover ?? defaultCover,
                              id: movie.id),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                if (movie.userRate != null)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                      Text('${movie.userRate}')
                                    ],
                                  ),
                                SizedBox(
                                  // width: screenWidth(context) * 0.2,
                                  child: AutoSizeText(
                                    '${movie.title}',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: imdbYellow,
                                    ),
                                    Text('${movie.rate}'),
                                    Text(
                                        '${movie.yearRange} ${movie.runtime}min'),
                                  ],
                                ),
                                Text('${movie.genres}'),
                                StarsOrDirector(
                                    names: movie.director ?? [],
                                    type: 'Director'),
                                StarsOrDirector(
                                  names: movie.stars ?? [],
                                  type: 'Star',
                                ),

                                AutoSizeText(
                                  '${movie.intro}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (!PlatformUtils.isDesktop) const Divider()
              ],
            );
          }
          return const SizedBox();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
