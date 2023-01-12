import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:imdb_bloc/cubit/loader_cubit.dart';
import 'package:imdb_bloc/widgets/loader.dart';

import 'package:sliver_tools/sliver_tools.dart';

import '../../../apis/movie_awards_api.dart';
import '../../../beans/movie_awards_bean.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/config_constants.dart';
import '../../../utils/common.dart';
import '../../../widgets/TitleAndSeeAll.dart';
import '../../../widgets/my_group_buttons.dart';
import '../../person/person_detail_screen.dart';

class MovieAwardsWidget extends StatefulWidget {
  const MovieAwardsWidget({Key? key, required this.mid}) : super(key: key);
  final String mid;
  @override
  State<MovieAwardsWidget> createState() => _MovieAwardsWidgetState();
}

class _MovieAwardsWidgetState extends State<MovieAwardsWidget> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (_length == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSeeAll(
            title: 'Awards',
            onTap: () {
              GoRouter.of(context).push('/awards/${widget.mid}');
            }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$_length award${_length! > 1 ? 's' : ''}'),
        )
      ],
    );
  }

  // Map? awards;
  int? _length;

  void _getData() async {
    // awards = await getMovieAwardsApi(widget.mid);
    // _length = 99;
    _length = await getMovieAwardsCountApi(widget.mid);
    if (mounted) {
      setState(() {});
    }
  }
}

class AwardsDetailsWidget extends StatefulWidget {
  const AwardsDetailsWidget(
      {Key? key,
      required this.awards,
      required this.onScrollEnd,
      required this.subjectId})
      : super(key: key);
  final Map awards;
  final Future Function() onScrollEnd;
  final String subjectId;
  @override
  State<AwardsDetailsWidget> createState() => _AwardsDetailsWidgetState();
}

class _AwardsDetailsWidgetState extends State<AwardsDetailsWidget>
    with SingleTickerProviderStateMixin {
  // final List<bool> _switches = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didUpdateWidget(covariant AwardsDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool _loading = false;
  final List<int> _switchOffs = [];
  late final TabController _tabController;
  String filter = 'All';
  final GroupButtonController _buttonController = GroupButtonController();
  @override
  Widget build(BuildContext context) {
    if (widget.awards.isEmpty) {
      return const SizedBox();
    }
    final mids = <String>[];
    final events = <String, List<List<String>>>{};
    final titles = <String>[];
    mids.clear();
    var awardsCnt = 0;
    for (var award in widget.awards.entries) {
      for (var sub in award.value.values.first.entries) {
        awardsCnt++;
        for (var nominee in sub.value['nominees']) {
          var id = nominee['subject_id'];
          var title = nominee['subject_name'];

          if (id.toString().startsWith('tt')) {
            if (!mids.contains(id)) {
              mids.add(id);
              titles.add(title);
            }
            events[id] ??= [];
            events[id]?.add([
              award.key,
              award.value.keys.first,
              sub.key,
              sub.value['nomination']['history_id']
            ]);
          }
        }
      }
    }

    // print(mids);
    return BlocProvider(
      create: (context) => LoaderCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Awards')),
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (detail) {
              if (detail.metrics.pixels < detail.metrics.maxScrollExtent ||
                  _loading) {
                return true;
              }
              var read = context.read<LoaderCubit>();
              read.beginLoading();
              widget.onScrollEnd().then((value) async {
                // (await Future.wait([Future.delayed(Duration(seconds: 2))]))[0];
                _loading = false;
                read.cancelLoading();
                if (mounted) {
                  setState(() {});
                }
              });

              return true;
            },
            child: widget.subjectId.startsWith('nm')
                ? Column(
                    children: [
                      TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: imdbYellow,
                          controller: _tabController,
                          tabs: [
                            Tab(
                              text: 'by Award ($awardsCnt awards)',
                            ),
                            Tab(
                              text: 'by Title (${mids.length} titles)',
                            )
                          ]),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _byAward(),
                            _byTitle(mids, events, titles)
                          ],
                        ),
                      ),
                    ],
                  )
                : _byAward(),
          ),
        );
      }),
    );
  }

  Padding _byTitle(List<String> mids, Map<String, List<List<String>>> events,
      List<String> titles) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: const SizedBox(),
            floating: true,
            flexibleSpace: Material(
              child: MyGroupButton(
                controller: _buttonController,
                buttons: const ['Winner', 'Nominee', 'All'],
                onSelected: (value, index, isSelected) {
                  filter = value.toString();
                  setState(() {});
                },
              ),
            ),
          ),
          ...mids.map(
            (mid) {
              var where = events[mid]!
                  .where((element) =>
                      element[1].contains(filter) || filter == 'All')
                  .toList();
              var title = titles[mids.indexOf(mid)];
              return MultiSliver(pushPinnedChildren: true, children: [
                if (where.isNotEmpty)
                  SliverPinnedHeader(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          // Get.to(() => MovieFullDetailScreenLazyLoad(mid: mid));
                          GoRouter.of(context).push('/title/$mid');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (where.isNotEmpty)
                  SliverList(
                      delegate: SliverChildBuilderDelegate(((context, index) {
                    var e = where[index];
                    var historyId = e.last;
                    return Card(
                      child: InkWell(
                        onTap: () async {
                          context.push('/event_history/$historyId');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: screenWidth(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${index + 1}'),
                                ...e.map<Widget>((text) => Text(text)).toList()
                                  ..removeAt(e.length - 1)
                                  ..add(const SizedBox(
                                    height: 10,
                                  ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }), childCount: where.length))
              ]);
            },
          ).toList()
        ],
      ),
    );
  }

  Scrollbar _byAward() {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: widget.awards.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.awards.length) {
            return _buildLoader();
          }
          final entries = widget.awards.entries.toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    // _switches[index] = !_switches[index];
                    if (_switchOffs.contains(index)) {
                      _switchOffs.remove(index);
                    } else {
                      _switchOffs.add(index);
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: ListTile(
                    title: Text(
                      entries[index].key.replaceAll('\n', ''),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              // _switches.isNotEmpty && _switches[index]
              !_switchOffs.contains(index)
                  ? SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ((entries[index].value as Map).entries)
                              .map((award) => Card(
                                    child: SizedBox(
                                      width: screenWidth(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${award.key}'
                                                  .replaceAll('\n', ' '),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: ((award.value as Map)
                                                    .entries)
                                                .map((subAward) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${subAward.key}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          _buildNomination(
                                                              subAward, true),
                                                          _buildNomination(
                                                              subAward, false),
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList()),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoader() {
    return const LoaderWidget();
  }

  Widget _buildNominee(nominee) {
    return InkWell(
      onTap: () {
        _onTextTap(nominee);
      },
      child: Text.rich(TextSpan(children: [
        TextSpan(
          text: '${nominee['subject_name']}',
          style: TextStyle(
              fontStyle: nominee['subject_id'].toString().startsWith('tt')
                  ? FontStyle.italic
                  : null,
              color: nominee['is_primary'] == true ? imdbYellow : Colors.blue),
        ),
        TextSpan(text: ' ${nominee['nominee_note'] ?? ''}')
      ])),
    );
  }

  void _onTextTap(nominee) {
    var id = nominee['subject_id'].toString();
    if (id.startsWith('tt')) {
      context.push('/title$id');
    } else {
      context.push('/person/$id');
    }
  }

  Widget _buildNomination(MapEntry subAward, bool isPrimary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${isPrimary ? 'Primary' : 'Secondary'} '),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ((subAward.value as Map)['nominees'] as List)
              .where((element) => element['is_primary'] == isPrimary)
              .map((nominee) => _buildNominee(nominee))
              .toList(),
        ),
      ],
    );
  }
}

class MovieAwardsDetailsWidget extends StatefulWidget {
  const MovieAwardsDetailsWidget({
    Key? key,
    required List<MovieAwardsBean> movieAwardsBeans,
  })  : _movieAwardsBeans = movieAwardsBeans,
        super(key: key);

  final List<MovieAwardsBean> _movieAwardsBeans;

  @override
  State<MovieAwardsDetailsWidget> createState() =>
      _MovieAwardsDetailsWidgetState();
}

class _MovieAwardsDetailsWidgetState extends State<MovieAwardsDetailsWidget> {
  final List<bool> _switches = [];
  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget._movieAwardsBeans.length; i++) {
      _switches.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._movieAwardsBeans.isEmpty) {
      return const SizedBox();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Awards')),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: widget._movieAwardsBeans.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    _switches[index] = !_switches[index];
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: ListTile(
                    title: Text(
                      widget._movieAwardsBeans[index].title!
                          .replaceAll('\n', ''),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              _switches.isNotEmpty && _switches[index]
                  ? SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (widget._movieAwardsBeans[index].subs ?? [])
                              .map((sub) => Card(
                                    child: SizedBox(
                                      width: screenWidth(context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${sub.subtitle}'
                                                  .replaceAll('\n', ' '),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: (sub.items ?? [])
                                                .map((items) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Builder(builder:
                                                              (context) {
                                                            var textsTmp =
                                                                (items.text ??
                                                                        '')
                                                                    .replaceAll(
                                                                        '\n',
                                                                        ' ')
                                                                    .split(
                                                                        '___');
                                                            var texts = [];
                                                            for (var text
                                                                in textsTmp) {
                                                              if (items
                                                                  .namesMapping!
                                                                  .containsKey(
                                                                      text)) {
                                                                texts.add(text);
                                                              } else {
                                                                texts.addAll(
                                                                    text.split(
                                                                        ' '));
                                                              }
                                                            }
                                                            return Wrap(
                                                              children: texts
                                                                  .map((text) {
                                                                if ((items.namesMapping ??
                                                                        {})
                                                                    .containsKey(
                                                                        text)) {
                                                                  return GestureDetector(
                                                                    child: Text(
                                                                      '$text ',
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                    onTap: () {
                                                                      _onTextTap(
                                                                          items,
                                                                          text);
                                                                    },
                                                                  );
                                                                }

                                                                return Text(
                                                                    '$text ');
                                                              }).toList(),
                                                            );
                                                          }),
                                                          if (sub.items!
                                                                  .indexOf(
                                                                      items) <
                                                              sub.items!
                                                                      .length -
                                                                  1)
                                                            const Divider()
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList()),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  void _onTextTap(Items items, String text) {
    if (items.namesMapping![text]!.startsWith('nm')) {
      context.push('/person/${items.namesMapping![text]!}');
    } else if (items.namesMapping![text]!.startsWith('tt')) {
      context.push('/title/${items.namesMapping![text]!}');
    }
  }
}
