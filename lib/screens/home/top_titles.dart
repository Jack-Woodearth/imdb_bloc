import 'package:dsc_utils/widgets/animated_expandable_list.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/screens/movies_list/MoviesListScreenLazyWithIds.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';
import 'package:imdb_bloc/utils/common.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import 'package:sliver_tools/sliver_tools.dart';
import '../../apis/events_api.dart';
import '../../apis/list_repr_images_api.dart';
import '../../apis/wahts_on_tv_api.dart';
import '../../beans/charts_resp.dart';
import '../../beans/genres.dart';
import '../../beans/list_resp.dart';
import '../../constants/colors_constants.dart';
import '../../constants/config_constants.dart';
import '../../enums/enums.dart';
import '../../utils/dio/dio.dart';
import '../../utils/dio/mydio.dart';
import '../../utils/list_utils.dart';
import '../../utils/platform.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/ThreePicturesAndTextWidget.dart';
import '../../widgets/my_network_image.dart';
import '../all_images/all_images.dart';
import '../movies_list/long_movie_list_genre_wrapper.dart';
import '../user_profile/youscreen.dart';
import 'top_titles_utils.dart';

class TopTitles extends StatefulWidget {
  const TopTitles({Key? key}) : super(key: key);
  final bool load = false;
  @override
  State<TopTitles> createState() => _TopTitlesState();
}

class _TopTitlesState extends State<TopTitles> {
  List<Chart> _charts = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Future.wait([getCharts(), getGenres()]);
    if (mounted) {
      setState(() {});
    }
  }

  List<ContentType> contentTypes = [];
  Future<void> getGenres() async {
    var resp = await MyDio().dio.get('$baseUrl/genre_names');
    if (reqSuccess(resp)) {
      // print(resp.data);
      contentTypes = GenreResp.fromJson(resp.data).result ?? [];
    }
  }

  Future<void> getCharts() async {
    var resp = await MyDio().dio.get('$baseUrl/chart');
    if (reqSuccess(resp)) {
      _charts = ChartsResp.fromJson(resp.data)
              .result
              ?.where((element) => element.ids?.isNotEmpty == true)
              .toList() ??
          [];
    }
  }

  // final bool _showTvGenresFull = false;
  // final bool _showMovieGenresFull = false;
  // final bool _showTopMoviesFull = true;
  // final bool _showWhatsOnTVFull = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), child: AppBar()),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            expandedHeight: 50,
            floating: true,
            title: Text(''),
          ),
          const WhatsOnTvGrid(),
          if (_charts.isNotEmpty) _buildTopMoviesTvs(),
          if (contentTypes.isNotEmpty)
            _buildMovieByGenre(
                contentTypes[0], context, 'Top movies by genre', Icons.movie),
          if (contentTypes.length > 1)
            _buildMovieByGenre(
                contentTypes[1], context, 'Top TV series by genre', Icons.tv),
          const EventsSlivers(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 60),
          )
        ],
      ),
    );
  }

  AnimatedExpandableSliverList<List<Chart>> _buildTopMoviesTvs() {
    return AnimatedExpandableSliverList<List<Chart>>(
        iconColor: imdbYellow,
        iconData: Icons.whatshot,
        items: splitList(_charts, 2),
        childBuilder: (chartRow) => Row(
              children: (chartRow as List<Chart>)
                  .map((chart) => SizedBox(
                        width: screenWidth(context) / 2,
                        height: screenWidth(context) / 2,
                        child: MovieListsCard(
                            onTap: () {
                              pushRoute(
                                  context: context,
                                  screen: MoviesListScreenLazyWithIds(
                                      movieIds: chart.ids!,
                                      name: '${chart.title}'));
                            },
                            pics: chart.covers ?? [],
                            title: '${chart.title}'),
                      ))
                  .toList(),
            ),
        title: 'Top movies and TVs');
  }

  AnimatedExpandableSliverList<List<Genre>> _buildMovieByGenre(
      ContentType contentType,
      BuildContext context,
      String title2,
      IconData iconData) {
    return AnimatedExpandableSliverList<List<Genre>>(
        iconData: iconData,
        iconColor: imdbYellow,
        items: splitList(contentType.genres ?? [], 3),
        childBuilder: (row) => SizedBox(
              child: Row(
                children: (row as List<Genre>)
                    .map((item) => SizedBox(
                          height: screenWidth(context) / 3,
                          width: screenWidth(context) / 3,
                          child: GestureDetector(
                            onTap: () {
                              pushRoute(
                                  context: context,
                                  screen: LongMovieListGenreWrapper(
                                    genre: item.genre ?? '',
                                    type: contentType.type!,
                                  ));
                            },
                            child: Card(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: StackedPictures(
                                      pictureWidth:
                                          screenWidth(context) / 3 / 3 / 1.2,
                                      pictures: item.covers ?? []),
                                ),
                                Expanded(
                                    child: Text(capInitial(item.genre ?? ''))),
                              ],
                            )),
                          ),
                        ))
                    .toList()
                    .cast<Widget>(),
              ),
            ),
        title: title2);
  }
}

class WhatsOnTvGrid extends StatefulWidget {
  const WhatsOnTvGrid({
    Key? key,
    // required this.showFull,
  }) : super(key: key);
  // final bool showFull;
  @override
  State<WhatsOnTvGrid> createState() => _WhatsOnTvGridState();
}

class _WhatsOnTvGridState extends State<WhatsOnTvGrid> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  final bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    if (_whatsOnTVCardDatum.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return AnimatedExpandableSliverList(
      items: splitList(_whatsOnTVCardDatum, 2),
      childBuilder: (row) => Row(
        children: (row as List<WhatsOnTVCardData?>)
            .map((e) => SizedBox(
                  width: screenWidth(context) / 2,
                  height: screenWidth(context) / 2,
                  child: WhatOnTvCardStateLess(
                    data: e,
                  ),
                ))
            .toList(),
      ),
      title: 'Whats on TV and stream',
      iconData: Icons.stream,
      iconColor: imdbYellow,
    );
  }

  List<WhatsOnTVCardData?> _whatsOnTVCardDatum = [];
  void _getData() async {
    var ids = await whatsOnTvApi();
    _whatsOnTVCardDatum = await batchGetWhatsOnTVCardData(ids);
    if (mounted) {
      setState(() {});
    }
  }
}

class WhatOnTvCardStateLess extends StatelessWidget {
  const WhatOnTvCardStateLess({super.key, this.data});
  final WhatsOnTVCardData? data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data?.listResult.listUrl != null) {
          // Get.to(() => NewListScreen(listUrl: data!.listResult.listUrl!));
          gotoListCreatedByImdbUserScreen(context, data!.listResult.listUrl!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Card(
          child: Column(
            children: [
              Expanded(
                  flex: 5,
                  child: Center(
                      child: StackedPictures(
                          pictures: data?.pics ?? [],
                          pictureWidth: screenWidth(context) /
                              PlatformUtils.gridCrossAxisCount(context) /
                              3 /
                              1.2))),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(data?.listResult.listName ?? ''),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MovieListsCard extends StatelessWidget {
  const MovieListsCard(
      {Key? key, required this.onTap, required this.pics, required this.title})
      : super(key: key);
  final VoidCallback onTap;
  final List<String> pics;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Card(
          child: Column(
            children: [
              Expanded(
                  flex: 5,
                  child: StackedPictures(pictures: pics, pictureWidth: 60)),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(title),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class StackedPictures extends StatelessWidget {
  const StackedPictures({
    Key? key,
    required this.pictures,
    required this.pictureWidth,
  }) : super(key: key);
  final double pictureWidth;
  final List<String> pictures;

  @override
  Widget build(BuildContext context) {
    // print('StackedPictures pictures.length=${pictures.length}');
    assert(pictures.length <= 3);
    if (pictures.length < 3) {
      for (var i = 0; i < 3 - pictures.length; i++) {
        pictures.add(defaultCover);
      }
    }
    double offset = pictureWidth / 2;
    double padding = 8;
    // if (pictures.length == 1) {
    //   return ClipRRect(
    //     borderRadius: BorderRadius.circular(8.0),
    //     child: AspectRatio(
    //       aspectRatio: 2 / 3,
    //       child: SizedBox(
    //         height: double.infinity,
    //         child: MyNetworkImage(
    //           url: smallPic(pictures[0]),
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return SizedBox(
      // alignment: Alignment.center,
      width: pictureWidth * pictures.length -
          offset * (pictures.length - 1) +
          padding * 2,
      child: Stack(
        // alignment: Alignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: pictures
            .map((e) => Positioned.fill(
                  right:
                      {0: -1.0, 1: 0.0, 2: 1.0}[pictures.indexOf(e)]! * offset,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                            // color: Colors.blue,
                            width: pictureWidth,
                            child: AspectRatio(
                                aspectRatio: 2 / 3,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: double.infinity,
                                      child: MyNetworkImage(
                                        url: smallPic(e),
                                      ),
                                    ),
                                    Container(
                                      color: pictures.indexOf(e) ==
                                              pictures.length - 1
                                          ? null
                                          : Colors.black26.withOpacity(0.3 +
                                              0.5 *
                                                  (1 -
                                                      pictures.indexOf(e) /
                                                          (pictures.length -
                                                              1))),
                                    )
                                  ],
                                ))),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class GenreGrid extends StatefulWidget {
  const GenreGrid({
    Key? key,
    required this.contentType,
    required this.showFull,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final ContentType contentType;
  final bool showFull;
  final String title;
  final IconData icon;
  @override
  State<GenreGrid> createState() => _GenreGridState();
}

class _GenreGridState extends State<GenreGrid> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  late final List<List<Genre>> _rows;
  late final List<List<Genre>> _rowsBak;
  @override
  void initState() {
    super.initState();
    _rows = splitList(widget.contentType.genres ?? [], 3);
    _rowsBak = _rows.toList();
  }

  void _addItem(List<Genre> row) {
    var index = _rows.length;
    _rows.add(row);
    _listKey.currentState?.insertItem(index);
  }

  void _removeItem() {
    if (_rows.isEmpty) {
      return;
    }
    var index = _rows.length - 1;
    var row = _rows.removeAt(index);

    _listKey.currentState?.removeItem(index, (context, animation) {
      return FadeTransition(
        opacity: animation,
        child: SizeTransition(
            sizeFactor: animation, child: _buildRow(row, context)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        // if (true)
        TitleWithIconSliverList(
            showArrow: true,
            arrowUp: false, //todo,
            onTap: () async {
              // _.toggleShow();//todo
              if (_rows.isNotEmpty) {
                while (_rows.isNotEmpty) {
                  _removeItem();
                }
              } else {
                for (var row in _rowsBak) {
                  _addItem(row);
                }
              }
            },
            title: widget.title,
            icon: widget.icon),

        SliverAnimatedList(
            key: _listKey,
            itemBuilder: ((context, index, animation) {
              var row = _rows[index];
              return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                      sizeFactor: animation, child: _buildRow(row, context)));
            }),
            initialItemCount: _rows.length),
      ],
    );
  }

  int _getCrossCount(BuildContext context) =>
      (PlatformUtils.screenAspectRatio(context) > 1 ? 6 : 3);

  Row _buildRow(
    List<Genre> row,
    BuildContext context,
  ) {
    return Row(
      children: row
          .map((item) => SizedBox(
                height: screenWidth(context) / 3,
                width: screenWidth(context) / 3,
                child: GestureDetector(
                  onTap: () {
                    // Get.to(() => LongMovieListGenreWrapper(
                    //       genre: item.genre ?? '',
                    //       type: widget.contentType.type!,
                    //     ));
                  },
                  child: Card(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: StackedPictures(
                            pictureWidth: screenWidth(context) /
                                _getCrossCount(context) /
                                3 /
                                1.2,
                            pictures: item.covers ?? []),
                      ),
                      Expanded(child: Text(capInitial(item.genre ?? ''))),
                    ],
                  )),
                ),
              ))
          .toList(),
    );
  }
}

class TitleWithIconSliverList extends StatelessWidget {
  const TitleWithIconSliverList({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.showArrow = false,
    this.arrowUp = false,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showArrow;
  final bool arrowUp;
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20, 0, 0),
                    child: SizedBox(
                      // onTap: onTap,
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: imdbYellow,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              title,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          showArrow
                              ? ExpandIcon(
                                  onPressed: (v) {
                                    onTap();
                                  },
                                  isExpanded: arrowUp,
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
            childCount: 1));
  }
}

class WhatsOnTvMultiSliver extends StatefulWidget {
  const WhatsOnTvMultiSliver({Key? key}) : super(key: key);

  @override
  State<WhatsOnTvMultiSliver> createState() => _WhatsOnTvMultiSliverState();
}

class _WhatsOnTvMultiSliverState extends State<WhatsOnTvMultiSliver> {
  final bool _showWhatsOnTVFull = true;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: const [
      // TitleWithIconSliverList(
      //   icon: Icons.stream,
      //   onTap: () {
      //     _showWhatsOnTVFull = !_showWhatsOnTVFull;
      //     setState(() {});
      //   },
      //   showArrow: true,
      //   arrowUp: _showWhatsOnTVFull,
      //   title: 'Whats on TV and stream',
      // ),
      WhatsOnTvGrid(
          // showFull: _showWhatsOnTVFull,
          ),
    ]);
  }
}

class EventsSlivers extends StatefulWidget {
  const EventsSlivers({Key? key}) : super(key: key);

  @override
  State<EventsSlivers> createState() => _EventsSliversState();
}

class _EventsSliversState extends State<EventsSlivers> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  List<String> _eventsNames = [];
  @override
  Widget build(BuildContext context) {
    if (_eventsNames.isEmpty) {
      return buildSingleChildSliverList(const SizedBox());
    }
    return AnimatedExpandableSliverList(
        items: _eventsNames,
        iconColor: imdbYellow,
        iconData: Icons.festival,
        childBuilder: (_) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: EventCard(
                eventName: _,
              ),
            ),
        title: 'Events');
  }

  SliverChildBuilderDelegate _delegate() {
    return SliverChildBuilderDelegate(
        (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: EventCard(
                eventName: _eventsNames[index],
              ),
            ),
        childCount: _eventsNames.length);
  }

  void _getData() async {
    _eventsNames = await eventsNames();
    print(_eventsNames.length);
    if (mounted) {
      setState(() {});
    }
  }
}

class EventCard extends StatefulWidget {
  const EventCard({
    Key? key,
    required this.eventName,
  }) : super(key: key);

  final String eventName;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant EventCard oldWidget) {
    if (oldWidget.eventName != widget.eventName) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
          onTap: () {
            pushRoute(
                context: context,
                screen: EventScreen(eventName: widget.eventName));
          },
          child: ListTile(
            title: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: MyNetworkImage(
                        url: (PlatformUtils.isDesktop
                            ? bigPic
                            : smallPic)(_cover ?? defaultCover))),
                Card(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.eventName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                )
              ],
            ),
            // subtitle:
          )),
    );
  }

  String? _cover;
  Future _getData() async {
    _cover = await getEventCoverApi(widget.eventName);

    if (mounted) {
      setState(() {});
    }
  }
}

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, required this.eventName}) : super(key: key);
  final String eventName;
  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant EventScreen oldWidget) {
    if (oldWidget.eventName != widget.eventName) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print(_eventDetail?.galleries);
    // print(_eventDetail?.lists);
    if (_eventDetail == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              var item = _eventDetail!.lists[index];
              return ListCard(item: item);
            }, childCount: _eventDetail!.lists.length),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              var item = _eventDetail!.galleries[index];
              if (item.isEmpty) {
                return const SizedBox();
              }
              return GalleryCard(gid: item.first.gid ?? '');
            }, childCount: _eventDetail!.galleries.length),
          ),
        ],
      ),
    );
  }

  EventDetail? _eventDetail;
  void _getData() async {
    _eventDetail = await eventDetailApi(widget.eventName);
    if (mounted) {
      setState(() {});
    }
  }
}

class ListCard extends StatefulWidget {
  const ListCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ListResult item;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant ListCard oldWidget) {
    if (oldWidget.item.listUrl != widget.item.listUrl) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ThreePicturesAndTextWidget(
      text: widget.item.listName ?? '',
      pictures: _images,
      onTap: () {
        if (widget.item.isPictureList == true) {
          // print(widget.item.pictures);
          pushRoute(
              context: context,
              screen: AllImagesScreen(
                data: AllImagesScreenData(
                  imageViewType: ImageViewType.listPicture,
                  subjectId: 'other',
                  title: widget.item.listName ?? '',
                  pictures: widget.item.pictures,
                ),
              ));
        } else {
          pushRoute(
              context: context,
              screen: MoviesListScreenLazyWithIds(
                  movieIds: widget.item.mids ?? [],
                  name: widget.item.listName ?? ''));
        }
      },
    );
  }

  List<String> _images = [];
  void _getData() async {
    _images = await getListReprImagesApi(widget.item.listUrl!);
    if (mounted) {
      setState(() {});
    }
  }
}
