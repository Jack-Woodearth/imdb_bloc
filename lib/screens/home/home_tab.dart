import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/apis/basic_info.dart';
import 'package:imdb_bloc/apis/event_history_api.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/list_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../apis/apis.dart';
import '../../apis/list_repr_images_api.dart';
import '../../apis/poll.dart';
import '../../beans/box_office_bean.dart';
import '../../beans/event_history_bean.dart';
import '../../beans/featured_today.dart';
import '../../beans/hero_videos.dart';
import '../../beans/home_resp.dart';
import '../../beans/news.dart';
import '../../constants/config_constants.dart';
import '../../utils/dio/mydio.dart';
import '../../utils/sp/sp_utils.dart';
import '../../utils/string/string_utils.dart';
import 'home_muti_slivers.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  HomeResp? _homeResp;

  Map<String, List<String>> ftAndEpImagesMap = {};

  var _heroVideos = <HeroVideos>[];

  var _featuredTodays = <FeaturedTodayOrEp>[];

  var _editorPicks = <FeaturedTodayOrEp>[];

  var _boxOfficeBeans = <BoxOfficeBean>[];

  List<NewsBean> _newsList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _resetData() {
    _homeResp = null;
    ftAndEpImagesMap.clear();
    _heroVideos.clear();
    _featuredTodays.clear();
    _editorPicks.clear();
    _boxOfficeBeans.clear();
    _newsList.clear();
  }

  bool _loading = true;

  Future _getData() async {
    _loading = true;

    debugPrint('home time:${DateTime.now()}');
    var t1 = DateTime.now();

    HomeResp? data = await getHomePage();
    if (data == null) {
      return;
    }
    _homeResp = data;
    _boxOfficeBeans = _homeResp?.result?.boxOfficeBeans ?? [];
    _heroVideos = (data.result?.heroVideos ?? <HeroVideos>[]);
    var ft = data.result?.featuredToday;
    var getFtData = _getFtOrEp(ft);
    _featuredTodays = getFtData.ftOrEps;
    var ep = data.result?.editorsPicks;
    var getEpData = _getFtOrEp(ep);
    _editorPicks =
        getEpData.ftOrEps.toSet().difference(_featuredTodays.toSet()).toList();
    var futures = getEpData.futures.toList()..addAll(getFtData.futures);
    var uniqIds = getEpData.uniqIds.toList()..addAll(getFtData.uniqIds);
    var futuresRes = await Future.wait(futures);
    for (var i = 0; i < futuresRes.length; i++) {
      ftAndEpImagesMap[uniqIds[i]] = futuresRes[i];
    }

    if (_homeResp?.result?.lists != null) {
      for (var list in _homeResp!.result!.lists!) {
        if (list.ids.isEmpty) {
          continue;
        }
        if (list.ids.first.startsWith('nm')) {
        } else if (list.ids.first.startsWith('tt')) {
        } else if (list.ids.first.startsWith('ni')) {
          getNewsApi(makeIdsString(list.ids, 'ni', '-')).then((value) {
            _newsList = value ?? [];
          });
        }
      }
    }

    await Future.delayed(const Duration(milliseconds: 200));
    _loading = false;

    var t2 = DateTime.now();
    debugPrint(
        'home getdata took ${t2.millisecondsSinceEpoch - t1.millisecondsSinceEpoch}ms');
    if (mounted) {
      setState(() {});
    }
  }

  FtOrEpData _getFtOrEp(
    List<FeaturedTodayOrEp>? ft,
  ) {
    List<Future<List<String>>> futures = [];
    List<String> uniqIds = [];
    if (ft != null) {
      var tmp = ft
          .where((element) => !isBlank(element.arguments?.linkTargetUrl))
          .toList();
      for (var item in tmp) {
        futures.add(_getFtOrEpImageWrapper(item));
        uniqIds.add(item.uniqId);
      }
      return FtOrEpData(ftOrEps: tmp, futures: futures, uniqIds: uniqIds);
    }
    return FtOrEpData(ftOrEps: [], uniqIds: [], futures: []);
  }

  Future<List<String>> _getFtOrEpImageWrapper(
      FeaturedTodayOrEp featuredToday) async {
    var linkTargetUrl = featuredToday.arguments?.linkTargetUrl;
    if (linkTargetUrl == null) {
      return [];
    }
    // return await getFtOrEpImage(linkTargetUrl);
    var list = await SpListCache.wrapped<String>(
        getFtOrEpImage, [linkTargetUrl],
        timeout: const Duration(days: 3));
    return list;
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  final RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SmartRefresher(
      enablePullDown: true,
      // enablePullUp: true,
      header: const WaterDropHeader(),
      controller: refreshController,
      child: HomeMultiSlivers(
              heroVideos: _heroVideos,
              featuredTodays: _featuredTodays,
              ftAndEpImagesMap: ftAndEpImagesMap,
              editorPicks: _editorPicks,
              boxOfficeBeans: _boxOfficeBeans,
              homeResp: _homeResp,
              newsList: _newsList)
          .build(context),
      onRefresh: () async {
        _resetData();
        await _getData();
        refreshController.refreshCompleted();
      },
    );
  }
}

class FtOrEpData {
  List<FeaturedTodayOrEp> ftOrEps;
  List<Future<List<String>>> futures;
  List<String> uniqIds;
  FtOrEpData(
      {required this.ftOrEps, required this.futures, required this.uniqIds});
}

Future<List<String>> getFtOrEpImage(String linkTargetUrl) async {
  if (linkTargetUrl == '') {
    return [];
  }
  if (linkTargetUrl.startsWith('/event/ev')) {
    final data = parseEventHistoryDataByUrl(linkTargetUrl);
    var eventHistoryBean = await getEventHistoryApi(null,
        eventId: data.evId, year: data.year, number: data.number);
    final ids = <String>[];
    for (var award in eventHistoryBean?.history?.awards ?? <Awards>[]) {
      for (var sub in award.subs ?? <Subs>[]) {
        for (var nomination in sub.nominations ?? <Nominations>[]) {
          for (var nominee in nomination.nominees ?? <Nominees>[]) {
            ids.add(nominee.subjectId);
            if (ids.length >= 3) {
              var infos = await getBasicInfoApi(firstNOfList(ids, 3));
              return infos.map((e) => e.image).toList();
            }
          }
        }
      }
    }
  }
  var listRet = await parseList(linkTargetUrl);
  if (listRet.isNotEmpty) {
    if (listRet.length >= 3) {
      return listRet;
    }
  }

  var url = (imdbHomeUrl + linkTargetUrl);

  var web = await getWebpageImages(url);
  if (web.length >= 3) {
    return web;
  }
  return await getListReprImagesApi(linkTargetUrl);
}

Future<List<String>> parseList(String url) async {
  //mediaviewer

  //list
  var listRe = RegExp(r'ls\d+');
  var listMatch = listRe.firstMatch(url);
  if (listMatch != null) {
    return await getListReprImagesApi('/list/${listMatch.group(0)}');
  }
  var re = RegExp(r'rg(\d+)/mediaviewer/rm\d+');
  if (re.hasMatch(url)) {
    var ret = <String>[];
    var gid =
        RegExp(r'rg\d+').firstMatch(re.firstMatch(url)!.group(0)!)!.group(0);
    var resp = await Dio().get('$baseUrl/gallery?gid=$gid');
    try {
      for (var item in resp.data['result'] ?? []) {
        ret.add(item['image']);
      }
    } catch (e) {
      debugPrint('parseList error: $e $url');
    }
    return ret;
  }
  //poll
  var rePoll = RegExp(r'/poll/\S+/');
  if (rePoll.hasMatch(url)) {
    var pollId = rePoll
        .firstMatch(url)!
        .group(0)!
        .replaceAll('/poll/', '')
        .replaceAll('/', '');

    var ret = <String>[];
    var pollResult = await getPollApi(pollId);
    try {
      for (var item in pollResult!.items!) {
        try {
          ret.add(item.subjectImage!);
        } catch (e) {}
      }
    } catch (e) {}
    return ret;
  }

  //list (old)
  var re2 = RegExp(r'/ls\d+/');
  if (!re2.hasMatch(url)) {
    return [];
  }

  var resp = await BasicDio().dio.get('$baseUrl/list?linkTargetUrl=$url');
  dp('parselist resp.statusCode:${resp.statusCode}');
  if (!resp.statusCode.toString().startsWith('2')) {
    return [];
  }

  var ret = <String>[];
  try {
    for (var item in resp.data['result']['details'] ?? []) {
      ret.addAll(item['photos'].cast<String>());
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  ret.shuffle();
  return ret;
}
