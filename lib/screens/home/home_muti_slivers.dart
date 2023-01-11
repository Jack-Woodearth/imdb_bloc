import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sliver_tools/sliver_tools.dart';

import '../../beans/box_office_bean.dart';
import '../../beans/featured_today.dart';
import '../../beans/hero_videos.dart';
import '../../beans/home_resp.dart';
import '../../beans/news.dart';
import '../../utils/common.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/TitleAndSeeAll.dart';
import '../../widgets/my_network_image.dart';
import 'NewsListScroll.dart';
import 'box_office_widget.dart';
import 'home_title.dart';
import 'home_top_slider.dart';
import 'poster_list_scroll.dart';

class HomeMultiSlivers {
  HomeMultiSlivers(
      {required this.heroVideos,
      required this.featuredTodays,
      required this.ftAndEpImagesMap,
      required this.editorPicks,
      required this.boxOfficeBeans,
      // required this.moviesMap,
      // required this.peopleMap,
      required this.newsList,
      required this.homeResp});
  final List<HeroVideos> heroVideos;
  final titles = <String>['Featured today', 'Editors\' picks', 'What to watch'];
  final List<FeaturedTodayOrEp> featuredTodays;
  final Map<String, List<String>> ftAndEpImagesMap;
  final List<FeaturedTodayOrEp> editorPicks;
  final List<BoxOfficeBean> boxOfficeBeans;
  // final Map<String, List<MovieBean>> moviesMap;
  // final Map<String, List<PersonBasicInfo>> peopleMap;
  final List<NewsBean> newsList;

  final HomeResp? homeResp;

  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: HomeTopSlider(heroVideos: heroVideos),
        ),
        // SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //         (context, index) => HomeTopSlider(heroVideos: heroVideos),
        //         childCount: 1)),

        //Featured today
        if (screenAspectRatio(context) <= 1)
          MultiSliver(pushPinnedChildren: true, children: [
            SliverPinnedHeader(
              child: HomeTitle(
                title: titles[0],
              ),
            ),
            _buildFTOrEP(featuredTodays),
          ]),

        //editors' picks
        if (screenAspectRatio(context) <= 1)
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              SliverPinnedHeader(
                child: HomeTitle(
                  // key: _controllers[1].keyScrollable,
                  title: titles[1],
                ),
              ),
              // _buildEP(),
              _buildFTOrEP(editorPicks)
            ],
          ),

        if (screenAspectRatio(context) > 1)
          SliverToBoxAdapter(
              child: SizedBox(
            height: 350,
            child: Row(
              children: {
                'Featured Tody': _buildFTOrEP(featuredTodays),
                "Editors's Picks":
                    //  _buildEP(),
                    _buildFTOrEP(editorPicks)
              }
                  .entries
                  .map<Widget>((e) => Expanded(
                        child: Column(
                          children: [
                            HomeTitle(
                              title: e.key,
                            ),
                            e.value,
                          ],
                        ),
                      ))
                  .toList()
                ..insert(
                    1,
                    const SizedBox(
                      width: 10,
                    )),
            ),
          )),
        //what to watch
        MultiSliver(pushPinnedChildren: false, children: [
          SliverPinnedHeader(
            child: HomeTitle(
              // key: _controllers[1].keyScrollable,
              title: titles[2],
            ),
          ),
        ]),
        BoxOfficeWidget(boxOfficeBeans: boxOfficeBeans),
        if (homeResp?.result?.lists != null)
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            var list = homeResp!.result!.lists![index];
            var isBobOffice = list.title.toLowerCase().contains('box');
            if (isBobOffice) {
              // return BoxOfficeWidget(boxOfficeBeans: boxOfficeBeans);
              return const SizedBox();
            }
            var isNews = list.ids.isNotEmpty && list.ids.first.startsWith('ni');
            if (isNews) {
              return (const SizedBox());
            }
            return (PosterListScrollLazy(
              title: list.title,
              ids: list.ids,
              // pageGetxControllerId: homeResp!.result!.lists!.indexOf(list),
            ));
          }, childCount: homeResp!.result!.lists!.length)),
        MultiSliver(children: [
          TitleAndSeeAll(
            title: 'Top news',
            onTap: () {},
          ),
          (NewsListScroll(newsList: newsList))
        ])
      ],
    );
  }

  Widget _buildEP() {
    return (SizedBox(
      // height: MediaQuery.of(context).size.width / 2,
      height: 250,
      child: PageView.builder(
        // controller: PageController(initialPage: 0),
        onPageChanged: (index) {
          // epIndex = index;
        },
        itemCount: editorPicks.length,
        itemBuilder: (context, index) {
          var e = editorPicks[index];
          return _buildEpOrFtItem(e, context);
        },
      ),
    ));
  }

  Widget _buildFTOrEP(List<FeaturedTodayOrEp> items) {
    return (SizedBox(
        // height: MediaQuery.of(context).size.width / 2,
        height: 250,
        child: PageView.builder(
          // controller: PageController(initialPage: 0),
          itemCount: items.length,
          onPageChanged: (index) {
            // ftIndex = index;
            // debugPrint(ftIndex);
          },
          itemBuilder: (context, index) {
            var e = items[index];
            return _buildEpOrFtItem(e, context);
          },
        )));
  }

  InkWell _buildEpOrFtItem(FeaturedTodayOrEp e, BuildContext context) {
    // assert(e is EditorsPicks || e is FeaturedToday);
    var images = ftAndEpImagesMap[e.uniqId] ?? [];
    if (images.length < 3) {
      debugPrint(
          'images.length < 3: e.arguments!.linkTargetUrl=${e.arguments?.linkTargetUrl}');
    }
    var text = e.arguments?.displayTitle ?? '';
    var link = e.arguments?.linkTargetUrl ?? 'no linkTargetUrl';
    return InkWell(
      onTap: () {
        _handFTorEpTap(e);
      },
      child: Stack(
        children: [
          Column(
            children: [
              _buildARowOfThreePictures(images, context),
              Text(
                text,
                maxLines: 1,
              ),
            ],
          ),
          Positioned(right: 5, top: 5, child: _buildALable(context, e))
        ],
      ),
    );
  }

  void _handFTorEpTap(FeaturedTodayOrEp e) {
    if ((e.arguments?.linkTargetUrl?.contains('list') == true ||
        e.arguments?.linkTargetUrl?.contains('/ls') == true)) {
      //todo
      // Get.to(
      //     () => MovieListDetailScreen(
      //           url: e.arguments!.linkTargetUrl!,
      //         ),
      //     transition: Transition.downToUp,
      //     duration: transitionDuration);
    } else if (e.arguments?.linkTargetUrl?.contains('/rg') == true &&
        e.arguments?.linkTargetUrl?.contains('/mediaviewer/') == true) {
      var gid =
          RegExp(r'rg\d+').firstMatch(e.arguments!.linkTargetUrl!)!.group(0)!;
      //todo
      // Get.to(
      //     () => GalleryScreen(
      //           gid: gid,
      //           galleryTitle: e.arguments?.displayTitle ?? '',
      //         ),
      //     transition: Transition.downToUp);
    } else if (e.arguments!.linkTargetUrl != null &&
        e.arguments!.linkTargetUrl!.contains('/poll/')) {
      //todo
      // Get.to(() => PollScreen(
      //     pollId: e.arguments!.linkTargetUrl!
      //         .replaceAll('poll', '')
      //         .replaceAll('/', '')));
    }
  }

  Row _buildARowOfThreePictures(List<String> images, BuildContext context) {
    var list = (images)
        .sublist(0, min(3, (images).length))
        .map((img) => Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: MyNetworkImage(
                    url: smallPic(img),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ))
        .toList();
    // 占位 防止只有1或2张图片时图片过宽
    if ([1, 2].contains(images.length)) {
      _addExpanded(3 - images.length, list);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  void _addExpanded(int flex, List<Expanded> list) {
    var expanded = Expanded(
      flex: flex,
      child: const SizedBox(),
    );
    list.insert(0, expanded);
    list.add(expanded);
  }

  Theme _buildALable(BuildContext context, FeaturedTodayOrEp e) {
    return Theme(
      data: Theme.of(context).copyWith(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white)),
      child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Container(
              color: Colors.grey[600]!.withOpacity(0.3),
              child:
                  _buildLabelWithoutTheme(e.arguments?.linkTargetUrl ?? ''))),
    );
  }

  Widget _buildLabelWithoutTheme(String url) {
    return Row(
      children: [
        Icon(
          url.startsWith('/list/') ? Icons.list : Icons.photo,
        ),
        Text(
          url.startsWith('/list/') ? 'list' : 'photo',
          // style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class PosterListScrollLazyIInheritedWidget extends InheritedWidget {
  const PosterListScrollLazyIInheritedWidget({
    super.key,
    this.showAge = false,
    required super.child,
  });

  final bool showAge;
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static PosterListScrollLazyIInheritedWidget of(BuildContext context) {
    final ret = context.dependOnInheritedWidgetOfExactType<
        PosterListScrollLazyIInheritedWidget>();
    assert(ret != null,
        'PosterListScrollLazyIInheritedWidget not found in context');
    return ret!;
  }
}
