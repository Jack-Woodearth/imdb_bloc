// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:synchronized/synchronized.dart';

import '../../../apis/apis.dart';
import '../../../apis/tv_seasons_api.dart';
import '../../../beans/cast_episodes_credits.dart';
import '../../../beans/details.dart';
import '../../all_cast/cast_episodes_credits_screen.dart';

class TvSeasonsInfoScreenData {
  final MovieBean movieBean;
  final int seasonCount;
  const TvSeasonsInfoScreenData(
      {required this.movieBean, required this.seasonCount});
}

class TvSeasonsInfoScreen extends StatefulWidget {
  const TvSeasonsInfoScreen({Key? key, required this.data}) : super(key: key);
  final TvSeasonsInfoScreenData data;

  @override
  State<TvSeasonsInfoScreen> createState() => _TvSeasonsInfoScreenState();
}

class _TvSeasonsInfoScreenState extends State<TvSeasonsInfoScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void dispose() {
    EasyLoading.dismiss();
    _tabController.removeListener(_listener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.data.seasonCount; i++) {
      _seasons.add([]);
    }
    _tabController = TabController(
        // animationDuration: Duration.zero,
        length: widget.data.seasonCount,
        vsync: this)
      ..addListener(_listener);
    _getSeason(1);
  }

  _listener() async {
    if (_seasons[_tabController.index].isEmpty) {
      print('listener _seasons[${_tabController.index}].isEmpty');
      await _lock.synchronized(() => _getSeason(_tabController.index + 1));

      // _getSeason(_tabController.index + 1);
    }
  }

  final Lock _lock = Lock();
  _getSeason(int season) async {
    if (_seasons[season - 1].isNotEmpty) {
      return;
    }
    Future.delayed(_tabController.animationDuration +
            const Duration(milliseconds: 200))
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
    // _lock.lock();
    try {
      EasyLoading.show();
      var seasonEpisodes =
          await getSeasonEpisodes(widget.data.movieBean.id!, season);
      var ids = seasonEpisodes?.map((e) => e.episodeMid!).toList() ?? [];
      var movieDetailsResp = await getMovieDetailsApi(ids);
      var details = movieDetailsResp?.result ?? [];
      var map = <String, MovieBean>{};
      for (var movie in details) {
        map[movie.id!] = movie;
      }
      _seasons[season - 1] = [];
      for (var ep in seasonEpisodes ?? []) {
        final m = map[ep.episodeMid]!;
        var tryParse = int.tryParse(
            (RegExp(r'\d{4}').firstMatch('${m.releaseDate}')?[0]) ?? '2099');
        _seasons[season - 1].add(CastEpisodesCredit(
            node: Node(
                title: ImdbTitle(
                    id: ep.episodeMid,
                    series: Series(
                      episodeNumber: EpisodeNumber(
                        seasonNumber: ep.seasonNumber,
                        episodeNumber: ep.episodeNumber,
                      ),
                    ),
                    releaseYear: ReleaseYear(
                      year: tryParse,
                    ),
                    releaseDate: m.releaseDate ?? '',
                    cover: m.cover,
                    runtime: m.runtime,
                    rate: m.rate,
                    originalTitleText: OriginalTitleText(text: m.title)))));
      }
      _seasons[season - 1].sort();
      EasyLoading.dismiss();
      if (mounted) {
        debugPrint('_getSeason $season setState ');

        //直接点击TabBar数字时，如果网络请求较快，则TabBarView切换的过渡动画还没有完成时请求就已经完成，
        //这时页面还处于过渡状态，setState(() {})没有效果
        //等过渡动画完成时，由于前面的setState(() {})已经执行过了，因此不会再执行（导致新的TabBarView不会执行build函数），
        //新的TabBarView的state停留在没有数据的状态，页面无数据展示
        //因此保险的做法是：每次网络请求后等过渡动画结束再setState(() {})
        //// 或者取消直接点击TabBar数字的过渡动画(duration=0)
        //或者在请求开始前开一个异步函数：等待过渡动画结束后setState(() {})
        //这样就保证请求结束时以及动画结束时都会刷新页面
        // await Future.delayed(_tabController.animationDuration);

        setState(() {});
      }
    } finally {
      // _lock.unlock();
    }
  }

  final List<List<CastEpisodesCredit>> _seasons = [];
  @override
  Widget build(BuildContext context) {
    // print(_tabController.index);
    return Scaffold(
      appBar: AppBar(title: const Text('Seasons')),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: TabBar(
              onTap: (i) {},
              isScrollable: true,
              tabs: _seasons
                  .map((e) => Text('${_seasons.indexOf(e) + 1}'))
                  .toList(),
              controller: _tabController,
            ),
          ),
          const Divider(
            height: 1,
          ),
          Expanded(
            child: TvSeasons(tabController: _tabController, seasons: _seasons),
          ),
        ],
      ),
    );
  }
}
