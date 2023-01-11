import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/top_movie_card_page_index_cubit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:scroll_to_index/scroll_to_index.dart';

import '../../apis/apis.dart';
import '../../apis/basic_info.dart';
import '../../apis/birth_date.dart';
import '../../beans/poster_bean.dart';
import '../../constants/config_constants.dart';
import '../../utils/common.dart';
import '../../utils/platform.dart';
import '../../widgets/TitleAndSeeAll.dart';
import '../../widgets/movie_poster_card.dart';
import '../../widgets/top_movie_cards_page_view.dart';

class PosterListScroll extends StatelessWidget {
  PosterListScroll(
      {Key? key,
      required this.title,
      // required this.subjects,
      // required this.pageGetxControllerId,
      required this.ids})
      : super(key: key);
  final String title;
  // final List<BasicInfo> subjects;
  final List<String> ids;
  // final int pageGetxControllerId;
  final AutoScrollController autoScrollController = AutoScrollController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 100,
      height: ids.isEmpty ? 60 : 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndSeeAll(
              title: title,
              onTap: () async {
                if (ids.first.startsWith('tt')) {
                  //todo
                  // Get.to(() => LongMovieListWrapper(
                  //       title: title,
                  //       ids: ids,
                  //     ));
                } else if (title == 'Born Today') {
                  EasyLoading.show();
                  var now = DateTime.now();
                  var birthrate = '${now.month}-${now.day}';

                  var resp = await getPeopleFromBirthDateApi(birthrate);
                  EasyLoading.dismiss();
                  //todo

                  // Get.to(() {
                  //   return PeopleBornList(
                  //       birthDate: birthrate, pids: resp.ids, resp: resp);
                  // });
                } else {
                  //todo

                  // Get.to(() => PersonListScreen(
                  //     count: ids.length, title: title, ids: ids));
                }
              }),
          Expanded(
            child: BlocProvider(
              create: (context) => TopMovieCardPageIndexCubit(),
              child: ListView.builder(
                  controller: autoScrollController,
                  // addAutomaticKeepAlives: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: min(100, ids.length),
                  itemBuilder: (context, index) {
                    // var subject = subjects[index];

                    // return _makeListItem(
                    //     subject, index, context, _scrollController);
                    return PosterListScrollItemLazy(
                        showAge: title == 'Born Today',
                        index: index,
                        // subject: subject,
                        mid: ids[index],
                        scrollController: autoScrollController,
                        // pageGetxControllerId: pageGetxControllerId,
                        title: title,
                        ids: ids);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class PosterListScrollItemLazy extends StatefulWidget {
  const PosterListScrollItemLazy(
      {Key? key,
      required this.mid,
      required this.scrollController,
      // required this.pageGetxControllerId,
      required this.title,
      required this.ids,
      required this.index,
      required this.showAge})
      : super(key: key);
  final String mid;
  final AutoScrollController scrollController;
  // final int pageGetxControllerId;
  final String title;
  final List<String> ids;
  final int index;
  final bool showAge;
  @override
  State<PosterListScrollItemLazy> createState() =>
      _PosterListScrollItemLazyState();
}

class _PosterListScrollItemLazyState extends State<PosterListScrollItemLazy>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // debugPrint('_PosterListScrollItemLazyState initState');
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_basicInfo == null) {
      // 占位
      return const PosterCard(posterUrl: defaultCover, title: '', id: '');
    }
    return PosterListScrollItem(
      showAge: widget.showAge,
      ids: widget.ids,
      index: widget.index,
      // pageGetxControllerId: widget.pageGetxControllerId,
      scrollController: widget.scrollController,
      subject: _basicInfo!,
      title: widget.title,
      hideRate: widget.title.toLowerCase().contains('coming soon'),
    );
  }

  BasicInfo? _basicInfo;
  Future _getData() async {
    var list = await getBasicInfoApi([widget.mid]);

    _basicInfo = list.first;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class PosterListScrollItem extends StatelessWidget {
  const PosterListScrollItem({
    Key? key,
    required this.subject,
    required AutoScrollController scrollController,
    // required this.pageGetxControllerId,
    required this.title,
    required this.ids,
    required this.index,
    this.hideRate = false,
    this.showAge = false,
  })  : _scrollController = scrollController,
        super(key: key);

  final BasicInfo subject;
  final AutoScrollController _scrollController;
  // final int pageGetxControllerId;
  final String title;
  final List<String> ids;
  final int index;
  final bool hideRate;
  final bool showAge;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: ((context) {
      var isMovie = subject.id?.startsWith('tt') == true;
      if (isMovie) {
        return AutoScrollTag(
          controller: _scrollController,
          index: index,
          key: ValueKey(index),
          child: PosterCard(
            // tinyImage: true,
            onTap: () {
              context.read<TopMovieCardPageIndexCubit>().set(index);
              //todo
              // Get.find<PageGetxController>(tag: '$pageGetxControllerId')
              //     .cur
              //     .value = index;
              // updateRecentViewed(subject.id!);
              if (PlatformUtils.isDesktop) {
                //todo
                // Get.to(() => Scaffold(
                //       appBar: AppBar(
                //         title: Text(title),
                //       ),
                //       body: TopMovieCardsPageView(
                //         pageGetxControllerId: pageGetxControllerId,
                //         title: title,
                //         // initialIndex: index,
                //         ids: ids,
                //       ),
                //     ));
              } else {
                showCupertinoModalBottomSheet(
                    topRadius: const Radius.circular(0),
                    backgroundColor: Colors.grey,
                    expand: true,
                    context: context,
                    builder: (_) {
                      return SizedBox(
                        height: screenHeight(context),
                        width: screenWidth(context),
                        child: Column(
                          children: [
                            Expanded(
                              child: BlocProvider.value(
                                value:
                                    context.read<TopMovieCardPageIndexCubit>(),
                                child: TopMovieCardsPageView(
                                    scrollController: _scrollController,
                                    title: title,
                                    // initialIndex: index,
                                    ids: ids),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
            // movieBean: movies[index],
            id: subject.id!,
            rank: index + 1,
            posterUrl: subject.image,
            title: subject.title ?? 'No_Title',
            rate: double.parse(subject.rate ?? '0'),
            hideRate: hideRate,
          ),
        );
      } else {
        var isPerson = subject.id?.startsWith('nm') == true;
        // print('isperson${subject.id}');
        if (isPerson) {
          return (PosterCard(
              showAge: showAge,
              id: subject.id!,
              // rank: index + 1,
              posterUrl: subject.image,
              title: subject.title ?? 'name unknown',
              age: subject.age));
        } else {
          return const SizedBox(
            width: 0,
            height: 0,
          );
        }
      }
    }));
  }
}

// class PosterListScrollLazyIInheritedWidget extends InheritedWidget {
//   const PosterListScrollLazyIInheritedWidget({
//     super.key,
//     this.showAge = false,
//     required super.child,
//   });

//   final bool showAge;
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return false;
//   }

//   static PosterListScrollLazyIInheritedWidget of(BuildContext context) {
//     final ret = context.dependOnInheritedWidgetOfExactType<
//         PosterListScrollLazyIInheritedWidget>();
//     assert(ret != null,
//         'PosterListScrollLazyIInheritedWidget not found in context');
//     return ret!;
//   }
// }

class PosterListScrollLazy extends StatefulWidget {
  const PosterListScrollLazy({
    Key? key,
    required this.title,
    required this.ids,
    // required this.pageGetxControllerId
  }) : super(key: key);
  final String title;
  final List<String> ids;
  // final int pageGetxControllerId;

  @override
  State<PosterListScrollLazy> createState() => _PosterListScrollLazyState();
}

class _PosterListScrollLazyState extends State<PosterListScrollLazy>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // debugPrint('_PosterListScrollLazyState initState');
    _getData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PosterListScrollLazy oldWidget) {
    if (oldWidget.title != widget.title) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('_PosterListScrollLazyState build');
    return PosterListScroll(
      // subjects: _subjects,
      title: widget.title,
      // pageGetxControllerId: widget.pageGetxControllerId,
      ids: widget.ids,
    );
  }

  // List<BasicInfo> _subjects = [];
  Future _getData() async {
    // _subjects = await getBasicInfoApi(widget.ids);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
}

// List<String> _ids(List<BasicInfo> subjects) =>
//     subjects.map((e) => e.id!).toList();
