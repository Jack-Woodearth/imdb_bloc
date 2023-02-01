import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/screens/all_cast/all_cast.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_details_screen_lazyload.dart';
import 'package:imdb_bloc/screens/movie_detail/tv_seasons_info/cubit/tv_seasons_info_cubit.dart';
import 'package:imdb_bloc/screens/movie_detail/tv_seasons_info/tv_seasons_info_screen.dart';
import 'package:imdb_bloc/utils/colors.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:imdb_bloc/widgets/trailers_widget.dart';

import 'package:sliver_tools/sliver_tools.dart';

import '../../../beans/poster_bean.dart';
import '../../apis/apis.dart';
import '../../apis/basic_info.dart';
import '../../apis/tv_seasons_api.dart';
import '../../apis/update_movie_api.dart';
import '../../apis/watchlist_api.dart';
import '../../beans/details.dart';
import '../../beans/seasons_info.dart';
import '../../utils/common.dart';
import '../../utils/platform.dart';
import '../../widgets/blured.dart';
import '../../widgets/my_network_image.dart';
import 'rate_movie_screen.dart';

class TopMovieCardLongLazy extends StatefulWidget {
  const TopMovieCardLongLazy(
      {Key? key, required this.showSeeFullDetails, required this.id})
      : super(key: key);
  final bool showSeeFullDetails;
  final String id;
  @override
  State<TopMovieCardLongLazy> createState() => _TopMovieCardLongLazyState();
}

class _TopMovieCardLongLazyState extends State<TopMovieCardLongLazy> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant TopMovieCardLongLazy oldWidget) {
    if (oldWidget.id != widget.id) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_movieBean == null) {
      return const SizedBox();
    }
    return TopMovieCardLong(
      movieBean: _movieBean!,
      showSeeFullDetails: widget.showSeeFullDetails,
    );
  }

  MovieBean? _movieBean;
  void _getData() async {
    var movieDetailsResp = await getMovieDetailsApi([widget.id]);
    try {
      _movieBean = movieDetailsResp!.result!.first;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {}
  }
}

class MidTitleAndSeeAll extends StatelessWidget {
  const MidTitleAndSeeAll(this.title, {Key? key, required this.seeMoreOnTap})
      : super(key: key);
  final Function() seeMoreOnTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MidTitle(
            title: title,
          ),
        ),
        SeeAll(
          onTap: seeMoreOnTap,
        ),
      ],
    );
  }
}

class MidTitle extends StatelessWidget {
  const MidTitle({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AutoSizeText(
        title,
        maxLines: 1,
        // minFontSize: 10,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SeeAll extends StatelessWidget {
  const SeeAll({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          'See All',
          style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.w400,
              fontSize: 15),
        ),
      ),
    );
  }
}

class TopMovieCardLong extends StatelessWidget {
  const TopMovieCardLong(
      {Key? key, required this.movieBean, this.showSeeFullDetails = true})
      : super(key: key);
  final MovieBean movieBean;
  final bool showSeeFullDetails;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        MovieDetailTopCardLongMultiSlivers(
            movieBean: movieBean, showSeeFullDetails: showSeeFullDetails)
      ],
    );
  }
}

class MovieDetailTopCardLongMultiSlivers extends StatefulWidget {
  const MovieDetailTopCardLongMultiSlivers({
    Key? key,
    required this.movieBean,
    this.showSeeFullDetails = true,
    // this.from,
    // this.cover,
  }) : super(key: key);
  final MovieBean movieBean;
  final bool showSeeFullDetails;
  // final String? cover;
  // final String? from;

  @override
  State<MovieDetailTopCardLongMultiSlivers> createState() =>
      _MovieDetailTopCardLongMultiSliversState();
}

class _MovieDetailTopCardLongMultiSliversState
    extends State<MovieDetailTopCardLongMultiSlivers>
    with SingleTickerProviderStateMixin {
  // final UserPersonalRateController _userPersonalRateController = Get.find();
  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MovieDetailTopCardLongMultiSlivers oldWidget) {
    if (oldWidget.movieBean.id != widget.movieBean.id) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future _getData() async {
    await Future.wait([]);
  }

  @override
  Widget build(BuildContext context) {
    var showTrailers =
        widget.movieBean.contentType?.toLowerCase().contains('episode') != true;
    return MultiSliver(
      children: [
        if (showTrailers && (PlatformUtils.screenAspectRatio(context) <= 1))
          TrailersWidget(
            movieBean: widget.movieBean,
            trailerShowMovieDetailIcon: false,
          ),

        if (PlatformUtils.screenAspectRatio(context) <= 1)
          _movieMainInfo(
            context,
          ),

        if (PlatformUtils.screenAspectRatio(context) > 1)
          Row(
            children: [
              if (showTrailers)
                Expanded(
                    child: TrailersWidget(
                        movieBean: widget.movieBean,
                        trailerShowMovieDetailIcon: false)),
              Expanded(
                  child: _movieMainInfo(
                context,
              )),
            ],
          ),
        // top cast title
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: MidTitleAndSeeAll(
            'Top Cast',
            seeMoreOnTap: () {
              context.push('/all_cast',
                  extra: AllCastScreenData(
                      mid: widget.movieBean.id!,
                      title: widget.movieBean.title!,
                      contentType: widget.movieBean.contentType));
            },
          ),
        ),
        // top cast scroll
        _topCast(),
        const SizedBox(
          height: 20,
        ),

        // top reviews title
        MidTitleAndSeeAll(
          'Top reviews',
          seeMoreOnTap: () {
            GoRouter.of(context).push('/reviews', extra: widget.movieBean);
          },
        ),

        //top reviews
        _topReviews(),

        //see full details
        if (widget.showSeeFullDetails) _seeFullDetailsButton(),
      ],
    );
  }

  Column _movieMainInfo(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //tvId info
        //episodeInfo
        if (widget.movieBean.episodeInfo != null)
          Row(
            children: [
              if (widget.movieBean.tvId != null)
                FutureBuilder(
                  future: getBasicInfoApi([widget.movieBean.tvId!]),
                  // initialData: InitialData,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<BasicInfo>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data?.isNotEmpty != true) {
                      return const SizedBox();
                    }
                    return InkWell(
                      onTap: () {
                        pushRoute(
                            context: context,
                            screen: MovieFullDetailScreenLazyLoad(
                                mid: widget.movieBean.tvId!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.keyboard_arrow_left),
                            AutoSizeText(
                              '${snapshot.data?[0].title}',
                              maxLines: 2,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              Text(
                '${widget.movieBean.episodeInfo}',
                style: TextStyle(
                    color: ImdbColors.themeYellow, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        _buildTitle(context),
        _buildContentTypeYearRangeParentalGuide(),
        _buildGenres(),
        // Episodes Guide
        if (isTvSeries(widget.movieBean.contentType)) _buildEpisodesGuide(),

        //cover and genre, plot
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // movie cover
              Expanded(
                  child: _buildCover(
                context,
              )),

              //movie plot
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildPlot(),
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Keywords: ${widget.movieBean.keywords ?? ''}'),
        ),
        _addToWatchListButton(context),

        //rate movie
        _buildRate(),
        const Divider(),
      ],
    );
  }

  Widget _topReviews() {
    return SizedBox(
      height: 150,
      // padding: const EdgeInsets.all(8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Card(
          // elevation: 0,
          // color: secondaryBlackOrWhite().withOpacity(0.05),
          child: Center(
            child: SizedBox(
              width: screenWidth(context) * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.movieBean.topReview ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ),
        itemCount: 1,
      ),
    );
  }

  Widget _topCast() {
    if (widget.movieBean.topCast?.isNotEmpty != true) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.movieBean.topCast?.length,
          itemBuilder: (BuildContext context, int index) {
            var e = widget.movieBean.topCast![index];
            return InkWell(
              onTap: () {
                //todo
                // Get.to(() => PersonDetailScreen(pid: e.id!));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Blurred(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: ColorsUtils.secondaryBlackOrWhite(context)
                        .withOpacity(0.08),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: MyNetworkImage(
                              url: smallPic(e.avatar),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e.name ?? '',
                            style: const TextStyle(fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _seeFullDetailsButton() {
    return CupertinoButton.filled(
        onPressed: () {
          GoRouter.of(context).pushNamed('/title', extra: widget.movieBean);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'See full details',
              style: TextStyle(color: Colors.blue[800]),
            ),
          ],
        ));
  }

  Padding _buildRate() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: _updateRate,
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: ImdbColors.themeYellow,
                ),
                Text('${widget.movieBean.rate}'),
                const Text(
                  '/10',
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 60,
          ),
          FutureBuilder<int?>(
              future: getUserPersonalRateApi(widget.movieBean.id!),
              builder: (context, snapshot) {
                // var rate = _userPersonalRateController.map[widget.movieBean.id];
                var rate = snapshot.data ?? 0;

                return InkWell(
                  onTap: () {
                    GoRouter.of(context).push('/title_rate',
                        extra: RateMovieScreenData(
                            movieBean: widget.movieBean,
                            userRate: snapshot.data));
                  },
                  child: Row(
                    children: [
                      Icon(
                        rate == 0
                            ? Icons.star_border_rounded
                            : Icons.star_rate_rounded,
                        color: Colors.blue[800],
                        // size: 18,
                      ),
                      Text(
                        rate == 0 ? 'Rate' : '$rate/10',
                        style: TextStyle(
                            // fontSize: 16,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget _addToWatchListButton(BuildContext context) {
    var animatedSwitcher = AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<UserWatchListCubit, UserWatchListState>(
            builder: (context, state) {
              return Text(
                '${state.ids.contains(widget.movieBean.id) ? 'Remove from' : 'Add to'} Watchlist',
                style: TextStyle(color: Colors.blue[800]),
                key: ValueKey(widget.movieBean.id!),
              );
            },
          ),
        ],
      ),
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Platform.isIOS || Platform.isMacOS
          ? CupertinoButton.filled(
              key: ValueKey(widget.movieBean.id!),
              onPressed: () {
                handleUpdateWatchListOrFavPeople(widget.movieBean.id!, context);
              },
              child: animatedSwitcher,
            )
          : ElevatedButton(
              onPressed: () {
                handleUpdateWatchListOrFavPeople(widget.movieBean.id!, context);
              },
              child: animatedSwitcher),
    );
  }

  Widget _buildPlot() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: FutureBuilder<String>(
          future: getPlotApi(widget.movieBean.id!),
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                GoRouter.of(context).pushNamed('/plot', queryParams: {
                  'movie': jsonEncode(widget.movieBean.toJson()),
                  'plot': snapshot.data ?? ''
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        snapshot.hasData
                            ? '${snapshot.data}'
                            : 'Loading plot...', //todo
                        // _plotCtrl.plot.value,
                        maxLines: 5,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right)
                ],
              ),
            );
          }),
    );
  }

  Wrap _buildGenres() {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: widget.movieBean.genre != null
          ? widget.movieBean.genre!
              .split(',')
              .map((e) => e.trim() == ''
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(right: 5),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(2),
                      //     border: Border.all(
                      //         color: Theme.of(context)
                      //             .colorScheme
                      //             .onBackground
                      //             .withOpacity(0.5),
                      //         width: 0.5)),
                      child: Chip(
                        label: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(e),
                        ),
                      ),
                    ))
              .toList()
          : [],
    );
  }

  InkWell _buildCover(
    BuildContext context,
  ) {
    return InkWell(
      onTap: _updateCover,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        // width: screenWidth(context) * 0.2,
        // height: screenWidth(context) * 0.2 * 1.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: MyNetworkImage(
            url: smallPic(widget.movieBean.cover), //todo
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesGuide() {
    return BlocProvider(
      create: (context) {
        var tvSeasonsInfoCubit = TvSeasonsInfoCubit();
        getSeasonsInfoApi(widget.movieBean.id!)
            .then((value) => tvSeasonsInfoCubit.set(value));
        return tvSeasonsInfoCubit;
      },
      child: Builder(builder: ((context) {
        return BlocBuilder<TvSeasonsInfoCubit, TvSeasonsInfoState>(
          builder: (context, state) {
            final info = state.info;
            return Row(
              children: [
                TextButton(
                    onPressed: () {
                      pushRoute(
                          context: context,
                          screen: TvSeasonsInfoScreen(
                              data: TvSeasonsInfoScreenData(
                                  movieBean: widget.movieBean,
                                  seasonCount:
                                      info != null && info.seasonCount != null
                                          ? info.seasonCount!
                                          : 1)));
                    },
                    child: const Text('EPISODES GUIDE')),
                Text(
                    '${pluralObjects(state.info?.seasonCount ?? 1, 'season')}, ${pluralObjects(state.info?.episodeCount ?? 0, 'episode')} '),
              ],
            );
          },
        );
      })),
    );
  }

  SizedBox _buildTitle(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.movieBean.title ?? '',
          // maxLines: 1,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  SingleChildScrollView _buildContentTypeYearRangeParentalGuide() {
    return SingleChildScrollView(
        child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              '${capInitial(widget.movieBean.contentType)} ${widget.movieBean.yearRange}  ${widget.movieBean.parentalGuide}',
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w100)),
        ),
        // Container(
        //     decoration: BoxDecoration(
        //         border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
        //     child: Padding(
        //       padding: const EdgeInsets.all(2.0),
        //       child: Text('${widget.movieBean.parentalGuide}'),
        //     ))
      ],
    ));
  }

  void _updateCover() async {
    // MovieCoverGetxController controller = Get.find(tag: widget.movieBean.id);
    // controller.loading.value = true;
    var newMovieBean = await updateMovieApi(
      widget.movieBean.id!,
    );
    if (newMovieBean != null) {
      widget.movieBean.cover = newMovieBean.cover;
    }
    // controller.cover.value = widget.movieBean.cover;
    // controller.loading.value = false;
  }

  void _updateRate() async {
    // _loadingRate = true;
    // MovieRateGetxController controller = Get.find(tag: widget.movieBean.id);
    // controller.loading.value = true;
    var futures = await Future.wait([
      updateMovieApi(
        widget.movieBean.id!,
      ),
      Future.delayed(const Duration(milliseconds: 500))
    ]);
    var movieBeanNew = futures[0];
    if (movieBeanNew != null) {
      widget.movieBean.rate = movieBeanNew.rate;
    }

    // controller.rate.value = widget.movieBean.rate ?? '0.0';
    // controller.loading.value = false;

    // _loadingRate = false;
  }
}

bool isTvSeries(String? contentType) {
  return '$contentType'.toLowerCase().contains('tv') &&
      '$contentType'.toLowerCase().contains('series');
}
