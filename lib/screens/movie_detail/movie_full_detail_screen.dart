import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/apis.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/enums/enums.dart';
import 'package:imdb_bloc/screens/all_images/all_images.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';

import 'package:sliver_tools/sliver_tools.dart';

import '../../apis/more_from.dart';
import '../../apis/movie_related_lists_polls_api.dart';
import '../../apis/watchlist_api.dart';
import '../../beans/details.dart';
import '../../beans/more_from.dart';
import '../../beans/movie_related_lists_polls.dart';
import '../../constants/config_constants.dart';
import '../../widget_methods/widget_methods.dart';
import '../../widgets/YellowDivider.dart';
import '../../widgets/movie_poster_card.dart';
import '../../widgets/my_network_image.dart';
import 'top_movie_card_long.dart';

// class ListWrapperWrapperOnlyListId extends StatefulWidget {
//   const ListWrapperWrapperOnlyListId({
//     Key? key,
//     required this.listUrl,
//   }) : super(key: key);

//   final String listUrl;

//   @override
//   State<ListWrapperWrapperOnlyListId> createState() =>
//       _ListWrapperWrapperOnlyListIdState();
// }

// class _ListWrapperWrapperOnlyListIdState
//     extends State<ListWrapperWrapperOnlyListId> {
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }

//   @override
//   void dispose() {
//     EasyLoading.dismiss();

//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(covariant ListWrapperWrapperOnlyListId oldWidget) {
//     if (oldWidget.listUrl != widget.listUrl) {
//       _getData();
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ids == null
//         ? const Center(child: CircularProgressIndicator())
//         : LongMovieListWrapper(
//             ids: ids!,
//             title: title,
//             total: ids!.length,
//           );
//   }

//   List<String>? ids;
//   String title = '';
//   void _getData() async {
//     EasyLoading.show();
//     var listResp =
//         await getListDetailApi(widget.listUrl, requireDetails: false);
//     ids = listResp.result!.mids!;
//     title = listResp.result!.listName ?? '';
//     EasyLoading.dismiss();
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }

class InfoRichText extends StatelessWidget {
  const InfoRichText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: content)
    ]));
  }
}

class BottomSheetMenuItem extends StatelessWidget {
  const BottomSheetMenuItem({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
          ],
        ),
      ),
    );
  }
}

class SmallTitleText extends StatelessWidget {
  const SmallTitleText({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
    );
  }
}

class TitleWithStartingYellowDivider extends StatelessWidget {
  const TitleWithStartingYellowDivider({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const YellowDivider(),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: MidTitle(title: title)),
        ],
      ),
    );
  }
}

class TitleAndSeeAll extends StatelessWidget {
  const TitleAndSeeAll(
      {Key? key, required this.title, this.label = '', required this.onTap})
      : super(key: key);
  final String title;
  final String label;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TitleWithStartingYellowDivider(
                  title: title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(label),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SeeAll(onTap: onTap),
          ),
        ),
      ],
    );
  }
}

class MovieFullDetailScreenData {
  List<MovieBean> recommendations;
  List<MoreFromResult>? moreFromResult;
  MovieRelatedListsPolls? movieRelatedListsPolls;
  MovieFullDetailScreenData(
      {this.moreFromResult,
      this.movieRelatedListsPolls,
      required this.recommendations});
}

class MovieFullDetailScreen extends StatefulWidget {
  const MovieFullDetailScreen({
    Key? key,
    required this.movieBean,
  }) : super(key: key);
  final MovieBean movieBean;

  @override
  State<MovieFullDetailScreen> createState() => _MovieFullDetailScreenState();
}

class _MovieFullDetailScreenState extends State<MovieFullDetailScreen> {
  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  void didChangeDependencies() {
    // dp('MovieFullDetailScreenState GoRouter.of(context).location=${GoRouter.of(context).location}');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MovieFullDetailScreen oldWidget) {
    if (oldWidget.movieBean.id != widget.movieBean.id!) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  // final bool _loading = true;
  Future<void> _getData() async {
    var futures = await Future.wait([
      // _getRecoms(),
      // _getMoreFrom(),
      // _getRelatedListsPolls(),
      // Future.delayed(const Duration(milliseconds: 500))
    ]);
    // _data = MovieFullDetailScreenData(
    //     // recomms: futures[0],
    //     recomms: [],
    //     // moreFromResult: futures[1],
    //     movieRelatedListsPolls: futures[2]);
    // if (mounted) {
    //   setState(() {});
    // }
    // return _data;
  }

  // MovieFullDetailScreenData? _data;
  List<MovieBean> _getRecoms() {
    // var recomIds = widget.movieBean.recommendations!.map((e) => e.id!).toList();
    // // var resp = await Dio()
    // //     .get(baseUrl + '/details?ids=${makeIdsString(recomIds, '', '-')}');

    // // var recoms = MovieDetailsResp.fromJson(resp.data).result ?? [];
    // var movieDetailsResp = await getMovieDetailsApi(recomIds);

    // return movieDetailsResp?.result ?? [];

    return widget.movieBean.recommendations
            ?.map((e) => MovieBean(
                  title: e.title,
                  rate: (e.rate ?? 0).toString(),
                  id: e.id ?? '',
                )..cover = e.cover ?? '')
            .toList() ??
        [];
  }

  // MoreFromResult? _moreFromResult;
  // Future<List<MoreFromResult>> _getMoreFrom() async {
  //   var tmp = await getMoreFromApi(widget.movieBean.id!);
  //   // _moreFromCtrl.moreFrom.value = tmp; //todo
  //   return tmp;
  // }

  // MovieRelatedListsPolls? _movieRelatedListsPolls;
  // Future<MovieRelatedListsPolls?> _getRelatedListsPolls() async {
  //   var tmp = await getMovieRelatedListsPollsApi(widget.movieBean.id!);
  //   // _relatedListsPollsCtrl.obj.value = tmp; //todo
  //   return tmp;
  // }
  late final recoms = widget.movieBean.recommendations
          ?.map((e) => MovieBean(
                title: e.title,
                rate: (e.rate ?? 0).toString(),
                id: e.id ?? '',
              )..cover = e.cover ?? '')
          .toList() ??
      [];
  @override
  Widget build(BuildContext context) {
    // var recoms = _getRecoms();
    // var _moreFromResult = _data?.moreFromResult;
    // var _movieRelatedListsPolls = _data?.movieRelatedListsPolls;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.movieBean.title} '),
        actions: [
          IconButton(
              onPressed: () {
                _showMenuBottomSheet(context);
              },
              icon: const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.more,
                    size: 20,
                  )))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (isDebug)
            buildSingleChildSliverList(
                SelectableText('${widget.movieBean.id}')),
          MultiSliver(children: [
            MovieDetailTopCardLongMultiSlivers(
              // from: widget.from,
              movieBean: widget.movieBean,
              showSeeFullDetails: false,
              // cover: widget.cover,
            ),
          ]),
          MultiSliver(children: [
            //Cast

            TitleAndSeeAll(
                title: 'Cast',
                onTap: () {
                  //todo
                  //   Get.to(() => AllCastScreen(
                  //       contentType: widget.movieBean.contentType,
                  //       mid: widget.movieBean.id!,
                  //       title: widget.movieBean.title ?? ''));
                }),

            if (widget.movieBean.topCast != null) (_buildCastListView()),

            Column(
              children: const [
                SizedBox(
                  height: 40,
                ),
                Divider(),
              ],
            ),

            // Director Writers

            _buildDirectorWriterInfo(),

            //awards
            //todo
            // MovieAwardsWidget(mid: widget.movieBean.id!),

            //More like this
            TitleAndSeeAll(
              title: 'More like this',
              label: '${recoms.length}',
              onTap: () async {
                EasyLoading.show();
                var newMovieListRespResult = await getNewListMoviesApi(
                    mids: recoms.map((e) => e.id!).toList());
                // dp('$newMovieListRespResult');
                if (newMovieListRespResult != null) {
                  GoRouter.of(context).pushNamed('/movies_list',
                      extra: MoviesListScreenData(
                          title: 'More like ${widget.movieBean.title}',
                          newMovieListRespResult: newMovieListRespResult));
                }
                EasyLoading.dismiss();
              },
            ),

            if (recoms.isEmpty &&
                widget.movieBean.recommendations?.isNotEmpty == true)
              (const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()))),

            //more like this
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recoms.length,
                itemBuilder: (BuildContext context, int index) {
                  var m = recoms[index];
                  return PosterCard(
                    id: m.id!,
                    posterUrl: m.cover,
                    title: m.title!,
                    rate: double.parse(m.rate ?? '0'),
                  );
                },
              ),
            ),

            _MoreFromSliverList(movieBean: widget.movieBean), //todo
            FutureBuilder(
              future: getMovieRelatedListsPollsApi(widget.movieBean.id!),
              builder: (BuildContext context,
                  AsyncSnapshot<MovieRelatedListsPolls?> snapshot) {
                return MultiSliver(children: [
                  // editorial lists
                  if (snapshot.data?.editorial?.isNotEmpty == true) ...[
                    const TitleWithStartingYellowDivider(
                      title: 'Editorial lists',
                    ),
                    _buildListsSliverList(snapshot.data?.editorial ?? [])
                  ],

                  // user lists
                  if (snapshot.data?.userLists?.isNotEmpty == true) //todo
                    ...[
                    const TitleWithStartingYellowDivider(
                      title: 'User lists',
                    ),
                    _buildListsSliverList(snapshot.data?.userLists ?? [])
                  ],

                  if (snapshot.data?.userPolls?.isNotEmpty == true) //todo
                    ...[
                    const TitleWithStartingYellowDivider(
                      title: 'User polls',
                    ),
                    _buildUserPolls(snapshot),
                  ],

                  //user polls
                ]);
              },
            ),
            //Images title
            TitleAndSeeAll(
                title: 'Images',
                onTap: () {
                  GoRouter.of(context).pushNamed('/photos',
                      extra: AllImagesScreenData(
                          subjectId: widget.movieBean.id ?? '',
                          title: widget.movieBean.title ?? '',
                          imageViewType: ImageViewType.movie));
                }),

            //Images ListView
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.movieBean.photos?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var url = widget.movieBean.photos![index].photoUrl;
                  if (isBlank(url)) {
                    return const SizedBox();
                  }
                  return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: MyNetworkImage(url: smallPic(url!)));
                },
              ),
            ),
          ])
        ],
      ),
    );
  }

  SliverList _buildUserPolls(AsyncSnapshot<MovieRelatedListsPolls?> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(((context, index) {
        UserPolls userPoll = snapshot.data!.userPolls![index]; //todo
        return Column(
          children: [
            InkWell(
              onTap: () {
                //todo
                // Get.to(() => PollScreen(pollId: userPoll.pollId!));
                context.push('/poll/${userPoll.pollId ?? ''}');
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: MyNetworkImage(
                          url: smallPic(userPoll.cover ?? defaultAvatar))),
                ),
                title: Text('${userPoll.pollTitle}'),
              ),
            ),
            const Divider(),
          ],
        );
      }), childCount: snapshot.data?.userPolls?.length ?? 0), //todo
    );
  }

  bool _locked = false;
  SliverList _buildListsSliverList(List<ListBean> lists) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        var listBean = lists[index];
        return Column(
          children: [
            InkWell(
              onTap: () async {
                if (_locked) {
                  return;
                }
                _locked = true;
                EasyLoading.show();
                var newMovieListRespResult =
                    await getNewListMoviesApi(listUrl: listBean.listUrl);
                if (newMovieListRespResult != null) {
                  GoRouter.of(context).pushNamed('/movies_list',
                      extra: MoviesListScreenData(
                          title: listBean.listName ?? '',
                          newMovieListRespResult: newMovieListRespResult));
                }
                EasyLoading.dismiss();
                _locked = false;
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: MyNetworkImage(
                        url: smallPic(listBean.cover ?? defaultAvatar)),
                  ),
                ),
                title: Text('${listBean.listName}'),
                subtitle: Text(
                  '${listBean.listDescription}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const Divider()
          ],
        );
      },
      childCount: lists.length,
    ));
  }

  SizedBox _buildCastListView() {
    return SizedBox(
      height: 150 * 1.5,
      child: ListView.builder(
        itemCount: widget.movieBean.topCast!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var person = widget.movieBean.topCast![index];
          return InkWell(
            onTap: () {
              //todo
              // Get.to(() => PersonDetailScreen(pid: person.id!));
            },
            child: SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                  child: AspectRatio(
                                aspectRatio: 2 / 3,
                                child: MyNetworkImage(
                                    url: smallPic(person.avatar)),
                              )),
                              Positioned(
                                  left: 5,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      handleUpdateWatchListOrFavPeople(
                                          person.id!, context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black87.withOpacity(0.5),
                                            border: Border.all(
                                                width: 0.9,
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Center(
                                            child: BlocBuilder<
                                                UserFavPeopleCubit,
                                                UserFavPeopleState>(
                                              builder: (context, state) {
                                                return Icon(
                                                  state.ids.contains(person.id!)
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                                  color: state.ids
                                                          .contains(person.id!)
                                                      ? ImdbColors.themeYellow
                                                      : Colors.white,
                                                );
                                              },
                                            ),
                                          ),
                                        )),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        child: Center(
                            child: Column(
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          person.name!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          person.as!.replaceAll(RegExp(r'\[|\]'), ''),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        )
                      ],
                    )))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildDirectorWriterInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.movieBean.directors != null &&
              widget.movieBean.directors!.isNotEmpty)
            InfoRichText(
              title: 'Director: ',
              content:
                  widget.movieBean.directors!.map((e) => e.name!).join(', '),
            )
          else
            InfoRichText(
                title: 'Creators: ',
                content:
                    widget.movieBean.creators?.map((e) => e.name!).join(', ') ??
                        ''),
          const Divider(),
          if (widget.movieBean.writers != null &&
              widget.movieBean.writers!.isNotEmpty)
            InfoRichText(
                title: 'Writers: ',
                content:
                    widget.movieBean.writers?.map((e) => e.name).join(', ') ??
                        '')
          else
            InfoRichText(
                title: 'Stars: ',
                content:
                    widget.movieBean.stars?.map((e) => e.name).join(', ') ??
                        ''),
          const Divider(),
          InkWell(
            onTap: () {
              //todo
              // Get.to(() => AllCastScreen(
              //     contentType: widget.movieBean.contentType,
              //     mid: widget.movieBean.id!,
              //     title: widget.movieBean.title!));
            },
            child: Row(
              children: const [
                SmallTitleText(title: 'All cast & crew'),

                // Text(movieBean.writers!.map((e) => e.name).join(', '))
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<dynamic> _showMenuBottomSheet(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        // backgroundColor: Theme.of(context).cardColor,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  //todo
                  // Get.to(() => SelectListScreen(
                  //       subjectId: widget.movieBean.id!,
                  //     ));
                },
                child: const Text('Add to List'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: const Text('Add a Review'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: const Text('Check in'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: const Text('Share'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                // Get.back();
                GoRouter.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          );
        });
  }
}

class _MoreFromSliverList extends StatefulWidget {
  const _MoreFromSliverList({required this.movieBean});
  final MovieBean movieBean;
  @override
  State<_MoreFromSliverList> createState() => __MoreFromSliverListState();
}

class __MoreFromSliverListState extends State<_MoreFromSliverList> {
  List<MoreFromResult>? _moreFromResults;
  Future<void> _getData() async {
    _moreFromResults = await getMoreFromApi(widget.movieBean.id!);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant _MoreFromSliverList oldWidget) {
    if (widget.movieBean.id != oldWidget.movieBean.id) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _getData();
    super.initState();
    dp('__MoreFromSliverListState initState');
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
      if (_moreFromResults?.isNotEmpty != true) {
        return const SizedBox();
      }
      MoreFromResult mf = _moreFromResults![index];
      var title = 'More from ${mf.personType} ${mf.personName}';

      return Column(
        children: [
          TitleAndSeeAll(
              title: title,
              onTap: () {
                if (mf.works != null) {
                  GoRouter.of(context).pushNamed('/movies_list',
                      extra: MoviesListScreenData(
                          title: title, newMovieListRespResult: mf.works!));
                  //todo
                  // Get.to(() => NewLongMovieList(
                  //       title: title,
                  //       newMovieListRespResult: mf.works!,
                  //       showFilters: false,
                  //     ));
                }
              }),
          if (mf.works?.movies?.isNotEmpty == true)
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: mf.works?.movies?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var m = mf.works!.movies![index];
                  if (m == null) {
                    return const SizedBox();
                  }
                  if (m.id == widget.movieBean.id) {
                    return const SizedBox();
                  }
                  return PosterCard(
                      rate: double.tryParse('${m.rate}'),
                      posterUrl: m.cover ?? defaultCover,
                      title: '${m.title}',
                      id: m.id);
                },
              ),
            )
        ],
      );
    }), childCount: _moreFromResults?.length ?? 0));
  }
}
