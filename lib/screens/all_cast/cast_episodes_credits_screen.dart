import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../apis/cast_episodes_credits_api.dart';
import '../../beans/cast_episodes_credits.dart';
import '../../beans/new_cast_episode_credit.dart';
import '../../constants/colors_constants.dart';
import '../../constants/config_constants.dart';
import '../../utils/date_utils.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_network_image.dart';
import '../movie_detail/movie_details_screen_lazyload.dart';

class CastEpisodesCreditsScreenData {
  final String mid;
  final String pid;
  final String avatar;
  final String personName;
  final String movieTitle;
  const CastEpisodesCreditsScreenData({
    required this.mid,
    required this.pid,
    required this.avatar,
    required this.personName,
    required this.movieTitle,
  });
}

class CastEpisodesCreditsScreen extends StatefulWidget {
  const CastEpisodesCreditsScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final CastEpisodesCreditsScreenData data;
  @override
  State<CastEpisodesCreditsScreen> createState() =>
      _CastEpisodesCreditsScreenState();
}

class _CastEpisodesCreditsScreenState extends State<CastEpisodesCreditsScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  void didUpdateWidget(covariant CastEpisodesCreditsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.mid != widget.data.mid ||
        oldWidget.data.pid != widget.data.pid) {
      _getData();
    }
  }

  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_credits.isEmpty) {
      return const Center(
        child: Text('Empty'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes(${_credits.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              leading: const SizedBox(),
              expandedHeight: 270,
              flexibleSpace: FlexibleSpaceBar(
                // height: 500,
                background: Material(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 150,
                            child: MyNetworkImage(
                              url: smallPic(widget.data.avatar),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data.personName,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(widget.data.movieTitle),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('${_credits.length} episodes')
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Builder(builder: (context) {
                          var as = <String>[];
                          for (var i = 0; i < _credits.length; i++) {
                            as.addAll(_credits[i].as!.split('/'));
                          }
                          print(as);
                          return Text(
                            'As ${as.map((e) => e.trim()).toSet().join(' /')}',
                            style: Theme.of(context).textTheme.titleSmall,
                          );
                        }),
                      ),
                      // const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => InkWell(
                          onTap: () {
                            GoRouter.of(context).push(
                                '/title/${_credits[index].episode?.id ?? ''}');
                          },
                          child: Column(
                            children: [
                              Builder(builder: (context) {
                                const width = 100.0;
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: width,
                                      height: width * 1.5,
                                      child: Builder(builder: (context) {
                                        try {
                                          return MyNetworkImage(
                                              url: _credits[index]
                                                      .episode
                                                      ?.cover ??
                                                  defaultCover);
                                        } catch (e) {
                                          return const Text('Image error');
                                        }
                                      }),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${_credits[index].episode?.seasonInfo ?? ''} ${_credits[index].episode?.title}',
                                              // '${credit.node!.title!.series!.episodeNumber!.episodeNumber}. ${credit.node!.title!.originalTitleText!.text}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                    '${_credits[index].episode?.releaseDate}'),
                                              ],
                                            ),
                                          ),
                                          if (_credits[index].episode?.rate !=
                                              null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.star_rate_rounded,
                                                    color: imdbYellow,
                                                  ),
                                                  Builder(builder: (context) {
                                                    try {
                                                      return Text(
                                                          _credits[index]
                                                                  .episode
                                                                  ?.rate ??
                                                              '');
                                                    } catch (e) {
                                                      return const Text('null');
                                                    }
                                                  }),
                                                ],
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                _credits[index].as.toString()),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                              const Divider(),
                            ],
                          ),
                        ),
                    childCount: _credits.length))
          ],
        ),
      ),
    );
  }

  List<NewCastEpisodeCredit> _credits = [];
  final List<List<CastEpisodesCredit>> _seasons = [];
  bool _loading = false;
  void _getData() async {
    _loading = true;
    _seasons.clear();
    for (var i = 0; i < 100; i++) {
      _seasons.add([]);
    }
    final tmp =
        await getCastEpisodesCreditsApi(widget.data.mid, widget.data.pid);
    _credits = tmp;
    _loading = false;
    setState(() {});
  }
}

class TvSeasons extends StatelessWidget {
  const TvSeasons({
    Key? key,
    required TabController tabController,
    required List<List<CastEpisodesCredit>> seasons,
  })  : _tabController = tabController,
        _seasons = seasons,
        super(key: key);

  final TabController _tabController;
  final List<List<CastEpisodesCredit>> _seasons;

  @override
  Widget build(BuildContext context) {
    // debugPrint('TvSeasons build');
    // debugPrint(_seasons[_tabController.index].toString() +
    //     'tabController.index=${_tabController.index}');
    return TabBarView(
      controller: _tabController,
      children: _seasons.map((season) {
        // print(_seasons.indexOf(season).toString() + season.length.toString());
        return CustomScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final credit = season[index];
                  return InkWell(
                    onTap: () {
                      context.push('/title/${credit.node?.title?.id ?? ''}');
                    },
                    child: Column(
                      children: [
                        Builder(builder: (context) {
                          const width = 100.0;
                          return Row(
                            children: [
                              SizedBox(
                                width: width,
                                height: width * 1.5,
                                child: Builder(builder: (context) {
                                  try {
                                    return MyNetworkImage(
                                        url: credit.node?.title?.cover ?? '');
                                  } catch (e) {
                                    return const Text('Image error');
                                  }
                                }),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${credit.node?.title?.series?.episodeNumber?.episodeNumber}. ${credit.node?.title?.originalTitleText?.text}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                              '${months[(credit.node?.title?.date.month ?? 0) - 1]} ${credit.node?.title?.date.day}, ${credit.node?.title?.releaseYear?.year} ${credit.node?.title?.runtime}m'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star_rate_rounded,
                                            color: imdbYellow,
                                          ),
                                          Builder(builder: (context) {
                                            try {
                                              return Text(credit
                                                      .node?.title?.rateDouble
                                                      .toStringAsFixed(1) ??
                                                  '');
                                            } catch (e) {
                                              return const Text('null');
                                            }
                                          }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                        const Divider(),
                      ],
                    ),
                  );
                }, childCount: season.length, addAutomaticKeepAlives: false),
              ),
            ]);
      }).toList(),
    );
  }
}
