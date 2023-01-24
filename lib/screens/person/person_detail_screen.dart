import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/screens/movies_list/MoviesListScreenLazyWithIds.dart';
import 'package:imdb_bloc/screens/people_screen/person_list_screen.dart';
import 'package:imdb_bloc/screens/person/cubit/person_photos_cubit.dart';
import 'package:imdb_bloc/widgets/scaffold_with_loading_mask.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import '../../apis/apis.dart';
import '../../apis/birth_date.dart';
import '../../apis/get_pics_api.dart';
import '../../apis/person.dart';
import '../../apis/person_bean_v2.dart';
import '../../apis/person_related_gallery.dart';
import '../../apis/watchlist_api.dart';
import '../../beans/new_list_result_resp.dart';
import '../../beans/person_awards_list_resp.dart';
import '../../constants/config_constants.dart';
import '../../enums/enums.dart';
import '../../utils/common.dart';
import '../../utils/platform.dart';
import '../../utils/string/string_utils.dart';
import '../../widget_methods/widget_methods.dart';
import '../../widgets/CenterText.dart';
import '../../widgets/FilmographySliverStack.dart';
import '../../widgets/PosterCardWrappedLazyLoadBean.dart';
import '../../widgets/TitleAndSeeAll.dart';
import '../../widgets/TitleWithStartingYellowDivider.dart';
import '../../widgets/YellowDivider.dart';
import '../../widgets/RelatedGalleriesWidget.dart';
import '../../widgets/my_network_image.dart';
import '../all_images/all_images.dart';

class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({Key? key, required this.pid}) : super(key: key);
  final String pid;

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  PersonResult? _personResult;

  @override
  void initState() {
    super.initState();
    updateRecentViewed(widget.pid, context);

    _getData();
  }

  final Lock _lockOfCommonMoviesBottomSheet = Lock();
  // final List<String> _photos = [];
  // late final PersonScreenPhotosCtrl _photosCtrl;
  // List<String> _workedWithIds = [];
  // List<MovieBean> filmography = [];
  List<MovieOfList?> _awardsMovies = [];
  List<AwardBean> _awards = [];
  List<String> _filmographyIds = [];
  final Map<String, Set<String>> _filmographyGroups = {};
  _getData() async {
    if (!widget.pid.startsWith('nm')) {
      EasyLoading.showError('Person does not exit');
      // Get.back();

      return;
    }
    var res = await Future.wait([
      Future.delayed(transitionDuration),
      getPersonFullDetailApi(widget.pid)
    ]);
    // _personBean = await getPersonFullDetailApi(widget.pid);
    _personResult = res[1];
    if (mounted) {
      setState(() {});
    }
    await Future.wait(
      [
        _getFilmography(),
        _getAwards(),
      ],
    );
    if (mounted) {
      setState(() {});
    }
    // updateRecentViewed(widget.pid, context);
  }

  Future<List<String>> _getWorkedWithIds() async {
    var ids = await getPersonWorkedWithIds(widget.pid);
    return ids;
  }

  Future<void> _getAwards() async {
    List<AwardBean> awards = await getAwardsApi(widget.pid);
    _awards = awards;
    var mids = _awards
        .map((e) => e.movieId!)
        .toSet()
        .toList()
        .where((element) => element != '')
        .toList();
    var newMovieListRespResult = await getNewListMoviesApi(mids: mids);
    _awardsMovies = newMovieListRespResult?.movies ?? [];
  }

  Future<void> _getFilmography() async {
    _filmographyGroups['Known for'] =
        (_personResult?.knownFor ?? []).map((e) => e.mid ?? '').toSet();

    if (_personResult?.filmography == null) {
      return;
    }
    for (var e in _personResult!.filmography!) {
      var key = capitalizeAll((e.filmographyType ?? '').replaceAll('_', ' '));
      _filmographyGroups[key] ??= {};
      _filmographyGroups[key]!.add(e.mid);
      _filmographyIds.add(e.mid);
    }

    _filmographyIds = _filmographyIds.toSet().toList();
  }

  Future<List<String>> _getPhotos() async {
    var photos = <String>[];

    try {
      photos = (_personResult?.person?.basicPhotos ?? []);

      if (photos.isNotEmpty) {
        return photos;
      }
    } catch (e) {}

    var res = await getPicsApi(widget.pid);
    photos = res.map((e) => e.photoUrl ?? '').toList();
    return photos;
  }

  Future<List<String>> _getRelatedGalleries() async {
    var gids = await getPersonRelatedGalleryApi(widget.pid);
    return gids;
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  Widget _buildPersonalDetailsItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DidYouKnowItem(
          didYouKnow: DidYouKnow(title: title, content: content)),
    );
  }

  bool _isMale() {
    if (_personResult?.filmography == null) {
      return false;
    }
    for (var element in _personResult!.filmography!) {
      if (element.filmographyType?.toLowerCase().contains('actor') == true) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var personPhotosCubit = PersonPhotosCubit();
        _getPhotos().then((value) => personPhotosCubit.set(value));
        return personPhotosCubit;
      },
      child: Builder(builder: (context) {
        return ScaffoldWithLoadingMask(child: _buildScaffold(context));
      }),
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_personResult?.person?.name ?? 'Person detail'),
        actions: [
          IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                  // backgroundColor: Theme.of(context).cardColor,
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                          onPressed: () {
                            context.push('/select_list/${widget.pid}');
                          },
                          child: const Text('Add to a list'))
                    ],
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        child: const Text('Cancel')),
                  ),
                );
              },
              icon: const Icon(Icons.more_horiz))
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              // firstChild: const Center(
              //   child: CircularProgressIndicator(),
              // ),
              child: _personResult == null
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        _getData();
                      },
                      child: CustomScrollView(
                        slivers: [
                          _buildPhotosCarousel(),
                          // avatar and info
                          if (PlatformUtils.screenAspectRatio(context) <= 1)
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    ((context, index) =>
                                        _buildAvatarAndInfo(context)),
                                    childCount: 1)),

                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  ((context, index) => _buildFilmography()),
                                  childCount: 1)),
                          if (PlatformUtils.screenAspectRatio(context) <= 1)
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    ((context, index) => _buildGalleries()),
                                    childCount: 1)),
                          if (PlatformUtils.screenAspectRatio(context) <= 1)
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    ((context, index) => _buildAwards()),
                                    childCount: 1)),

                          if (PlatformUtils.screenAspectRatio(context) > 1)
                            buildSingleChildSliverList(Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildGalleries()),
                                Expanded(child: _buildAwards())
                              ],
                            )),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            TitleAndSeeAll(
                                title: "Personal details", onTap: () {}),
                            if (_personResult
                                    ?.person?.officialSites?.isNotEmpty ==
                                true)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Official sites',
                                      style: DidYouKnowItem.titleTextStyle,
                                    ),
                                    Wrap(
                                      children: (_personResult
                                                  ?.person?.officialSites ??
                                              [])
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: InkWell(
                                                  child: Text(
                                                    e.label ?? '',
                                                    style: const TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                  onTap: () {
                                                    if (!isBlank(e.url)) {
                                                      launchUrl(Uri.parse(
                                                          e.url ?? ''));
                                                    }
                                                  },
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  ],
                                ),
                              ),
                            if (_personResult?.person?.akas?.isNotEmpty == true)
                              _buildPersonalDetailsItem(
                                  'AKAs',
                                  _personResult?.person?.akas?.join(', ') ??
                                      ""),
                            if (!isBlank(_personResult?.person?.height))
                              _buildPersonalDetailsItem('Height',
                                  _personResult?.person?.height ?? ''),
                            if (_personResult?.person?.awards?.isNotEmpty ==
                                true)
                              _buildPersonalDetailsItem('Awards',
                                  _personResult?.person?.awards ?? ''),
                            if (_personResult?.person?.wins != null &&
                                (_personResult?.person?.wins ?? 0) > 0)
                              _buildPersonalDetailsItem('Awards wins',
                                  '${_personResult?.person?.wins}'),
                            if (_personResult?.person?.nominations != null &&
                                (_personResult?.person?.nominations ?? 0) > 0)
                              _buildPersonalDetailsItem('Awards nominations',
                                  '${_personResult?.person?.nominations}'),
                            if (_personResult?.person?.spouse != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Spouse',
                                      style: DidYouKnowItem.titleTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (_personResult
                                                  ?.person?.spouse ??
                                              [])
                                          .map((e) => InkWell(
                                                onTap: () {
                                                  if (!isBlank(
                                                      e.spouse?.name?.id)) {
                                                    context.push(
                                                        '/person/${e.spouse?.name?.id}');
                                                  }
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.spouse?.name?.nametext
                                                              ?.text ??
                                                          '',
                                                      style: const TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    Text(
                                                        ' (${e.timerange?.displayableproperty?.value?.plaidhtml}, ${(e.attributes ?? []).map((e) => e.id ?? '').join(', ')})')
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            if (_personResult?.person?.children?.isNotEmpty ==
                                true)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Children',
                                      style: DidYouKnowItem.titleTextStyle,
                                    ),
                                    ...(_personResult?.person?.children ?? [])
                                        .map((e) => InkWell(
                                              onTap: () {
                                                if (!isBlank(e.id)) {
                                                  context
                                                      .push('/person/${e.id}');
                                                }
                                              },
                                              child: Text(
                                                e.name ?? '',
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ))
                                        .toList()
                                  ],
                                ),
                              )
                          ])),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  ((context, index) => _buildDidYouKnow()),
                                  childCount: 1)),
                          // SliverList(
                          //     delegate: SliverChildBuilderDelegate(
                          //         ((context, index) => _buildPersonalDetails()),
                          //         childCount: 1)),
                          SliverList(
                              delegate:
                                  SliverChildBuilderDelegate(((context, index) {
                            var pronoun = _isMale() ? 'he' : 'she';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const YellowDivider(),
                                  InkWell(
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Show people  work with',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: ((context) =>
                                      //         Dialog(child: _buildWorkedWith())));
                                      debugPrint('statement123456456465456');
                                      showCupertinoModalPopup(
                                          context: context,
                                          builder: (_) => Material(
                                              child: SizedBox(
                                                  height:
                                                      screenHeight(context) / 2,
                                                  child: _buildWorkedWith())));
                                    },
                                  ),
                                ],
                              ),
                            );
                          }), childCount: 1)),

                          //editorial
                          if (_personResult
                                  ?.person?.editorialLists?.isNotEmpty ==
                              true)
                            const SliverToBoxAdapter(
                              child: TitleWithStartingYellowDivider(
                                title: 'Editorial lists',
                              ),
                            ),
                          _buildUserLists(
                              _personResult?.person?.editorialLists ?? [],
                              context),
                          //userLists
                          if (_personResult?.person?.userLists?.isNotEmpty ==
                              true)
                            const SliverToBoxAdapter(
                              child: TitleWithStartingYellowDivider(
                                title: 'User lists',
                              ),
                            ),
                          _buildUserLists(
                              _personResult?.person?.userLists ?? [], context),
                          if (_personResult?.person?.userPolls?.isNotEmpty ==
                              true)
                            const SliverToBoxAdapter(
                                child: TitleWithStartingYellowDivider(
                              title: 'User polls',
                            )),

                          _buildUserPolls(),
                        ],
                      ),
                    ),
            ),
          ),

          //debug
          SelectableText(widget.pid),
        ],
      ),
    );
  }

  SliverList _buildPhotosCarousel() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            ((context, index) => BlocBuilder<PersonPhotosCubit,
                    PersonPhotosState>(
                builder: (context, state) => Column(
                      children: [
                        state.photos.isEmpty
                            ? const SizedBox(
                                height: 200,
                                child: Center(child: Text('Loading photos...')),
                              )
                            :
                            // photos
                            _buildPhotosCarouselSlider(context, state.photos)
                      ],
                    ))),
            childCount: 1));
  }

  SliverList _buildUserPolls() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
      var e = _personResult!.person!.userPolls![index];
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 2),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                context.push('/poll/${e.pollId ?? ''}');
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: MyNetworkImage(
                      url: e.cover ?? defaultCover,
                    ),
                  ),
                ),
                title: Text('${e.pollTitle}'.split('\n').first),
                // subtitle: Text('${e.url}'),
              ),
            ),
            const Divider()
          ],
        ),
      );
      // return const SizedBox();
    }), childCount: (_personResult?.person?.userPolls ?? []).length));
  }

  SliverList _buildUserLists(List<RelatedLists> lists, BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
      var e = lists[index];
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 2),
        child: InkWell(
          onTap: () async {
            gotoListCreatedByImdbUserScreen(context, e.listUrl!);
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: MyNetworkImage(url: smallPic(e.cover ?? defaultAvatar)),
              ),
            ),
            title: Text('${e.listName}'),
            subtitle: Builder(builder: (context) {
              return Text(e.listDescription ?? '');
            }),
          ),
        ),
      );
    }), childCount: (lists).length));
  }

  Widget _buildAvatarAndInfo(BuildContext context) {
    return Column(
      children: [
        _buildPersonJobs(),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // avatar
            Expanded(child: _buildPersonAvatar()),

            //person info
            Expanded(
              flex: 3,
              child: _buildPersonInfo(context),
            )
          ],
        ),
        _buildWatchListButton(context)
      ],
    );
  }

  Widget _buildNameAndJobs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Divider(),

        // name
        // Text(
        //   _personBean!.person!.name!,
        //   style: Theme.of(context).textTheme.headline5,
        // ),

        // jobs
        _buildPersonJobs(),
      ],
    );
  }

  Widget _buildWorkedWith() {
    return FutureBuilder(
      future: _getWorkedWithIds(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        return Column(
          children: [
            TitleAndSeeAll(
                title: 'Worked with',
                label: '${snapshot.data!.length}',
                onTap: () {
                  context.push('/people_list',
                      extra: PeopleListScreenData(
                          count: snapshot.data!.length,
                          ids: snapshot.data!,
                          title:
                              'People worked with ${_personResult?.person?.name}'));
                }),
            SizedBox(
              height: 300,
              child: snapshot.data!.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // print(personBean!.person!.id);
                        // print(personBean!.knownFor!.length);

                        return Column(
                          children: [
                            SizedBox(
                              height: 250,
                              child: PosterCardWrappedLazyLoadBean(
                                  id: snapshot.data![index]),
                            ),
                            TextButton(
                              child: const Icon(
                                Icons.more_horiz,
                              ),
                              onPressed: () async {
                                await _handleShowCommonMovies(
                                    index, context, snapshot.data!);
                              },
                            )
                          ],
                        );
                      },
                      itemCount: snapshot.data!.length,
                    ),
            ),
          ],
        );
      },
    );
  }

  Column _buildKnowFor(List<String> ids) {
    return Column(
      children: [
        TitleAndSeeAll(title: 'Known for', onTap: () {}),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              // print(personBean!.person!.id);
              // print(personBean!.knownFor!.length);

              return PosterCardWrappedLazyLoadBean(id: ids[index]);
            },
            itemCount: ids.length,
          ),
        )
      ],
    );
  }

  final _currentPageNotifier = ValueNotifier<int>(0);

  Widget _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: _awardsMovies.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  Widget _buildAwards() {
    if (_awardsMovies.isEmpty) {
      return const SizedBox();
    }
    const additionalWidgetHeight = 200.0;
    return Column(
      children: [
        TitleAndSeeAll(
            title: 'Awards',
            onTap: () {
              context.push('/awards/${widget.pid}');
            }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: additionalWidgetHeight,
            child: Column(
              // alignment: Alignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    // controller: PageController(),
                    onPageChanged: (index) {
                      _currentPageNotifier.value = index;
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _awardsMovies.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_awardsMovies[index] == null) {
                        return const SizedBox();
                      }
                      return InkWell(
                        onTap: () {
                          context.push('/title/${_awardsMovies[index]!.id}');
                        },
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 2 / 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: MyNetworkImage(
                                      url: smallPic(
                                          _awardsMovies[index]!.cover ??
                                              defaultCover)),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CenterText(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        text:
                                            '${_awardsMovies[index]!.title ?? ''} (${getAwardBean(_awardsMovies[index]!)!.year} ) '),
                                    CenterText(
                                        text:
                                            'IMDb rate: ${double.parse(_awardsMovies[index]!.rate ?? '0').toStringAsFixed(1)}'),
                                    CenterText(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        text:
                                            getAwardBean(_awardsMovies[index]!)!
                                                    .awardName ??
                                                ''),
                                    CenterText(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      text: getAwardBean(_awardsMovies[index]!)!
                                              .awardDescription ??
                                          '',
                                    ),
                                    CenterText(
                                      text: getAwardBean(_awardsMovies[index]!)!
                                              .awardOutcome ??
                                          '',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // _buildCircleIndicator()
                SizedBox(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CirclePageIndicator(
                      size: min(
                          screenWidth(context) / _awardsMovies.length / 2, 8.0),
                      dotSpacing:
                          screenWidth(context) / _awardsMovies.length / 3,
                      itemCount: _awardsMovies.length,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDidYouKnow() {
    // return const SizedBox();
    if (_personResult?.person?.didYouKnow?.isNotEmpty != true) {
      return const SizedBox();
    }
    return Column(
      children: [
        const TitleWithStartingYellowDivider(
          title: 'Did you know',
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            try {
              return InkWell(
                onTap: () {
                  final person = _personResult;
                  showDialog(
                      context: context,
                      builder: ((context) =>
                          DidYouKnowDetailScreen(person: person)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DidYouKnowItem(
                          didYouKnow: _personResult!.person!.didYouKnow!.first),
                    ),
                    const Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              );
            } catch (e) {
              return const SizedBox(
                  // height: 0,
                  );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildFilmography() {
    if (_filmographyGroups.entries.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        TitleAndSeeAll(
          title: 'Filmography',
          label: '${_filmographyIds.length}',
          onTap: () async {
            var filmographyIds = _filmographyIds.toList();
            var name = _personResult?.person?.name ?? '';
            pushRoute(
                context: context,
                screen: MoviesListScreenLazyWithIds(
                    movieIds: filmographyIds, name: name));
          },
        ),
        SizedBox(
          height: 300,
          child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: _filmographyGroups.entries.map(
                (e) {
                  const headerFontSize = 15.0;

                  return FilmographySliverStack(
                    headerWidth: e.key.trim().length * headerFontSize,
                    header: Text(
                      e.key.trim(),
                      style: TextStyle(
                          color: ImdbColors.themeYellow,
                          fontSize: headerFontSize),
                    ),
                    children: e.value
                        .map((movieId) =>
                            PosterCardWrappedLazyLoadBean(id: movieId))
                        .toList(),
                  );
                },
              ).toList()),
        ),
      ],
    );
  }

  Widget _buildGalleries() {
    // return const SizedBox();
    return FutureBuilder<List<String>>(
      future: _getRelatedGalleries(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data?.isNotEmpty != true) {
          return const SizedBox();
        }
        return Column(
          children: [
            const TitleWithStartingYellowDivider(
              title: 'Related galleries',
            ),
            RelatedGalleriesWidget(gids: snapshot.data!),
          ],
        );
      },
    );
  }

  Widget _buildWatchListButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Builder(
              builder: (context) => CupertinoButton(
                  onPressed: () {
                    handleUpdateWatchListOrFavPeople(widget.pid, context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: BlocBuilder<UserFavPeopleCubit, UserFavPeopleState>(
                      builder: (context, state) {
                        return Container(
                            color: !state.ids.contains(widget.pid)
                                ? Theme.of(context).cardColor
                                : ImdbColors.themeYellow,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(!state.ids.contains(widget.pid)
                                      ? Icons.add
                                      : Icons.remove),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  BlocBuilder<UserFavPeopleCubit,
                                      UserFavPeopleState>(
                                    builder: (context, state) {
                                      return Text(
                                        '${!state.ids.contains(widget.pid) ? 'Add to' : 'Remove from'} favorites',
                                        style: TextStyle(
                                            color:
                                                !state.ids.contains(widget.pid)
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color
                                                    : Colors.red),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ))),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }

  SingleChildScrollView _buildPersonJobs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: (_personResult?.person?.jobs ?? [])
            .map((e) => e.category ?? '')
            .where((element) =>
                !['thanks', 'self', 'archive_footage'].contains(element))
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(capInitial(e)),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPersonInfo(BuildContext context) {
    var split = '${_personResult?.person?.birthDate}'.split('-');
    var birthDate = '';
    try {
      birthDate = split.sublist(1, 3).join('-');
    } catch (e) {}
    return InkWell(
      onTap: () {
        context.push('/person_bio/${widget.pid}');
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          // width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _personResult?.person?.intro ?? 'No content',
                maxLines: 5,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
              !isBlank(_personResult?.person?.birthDate)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                              text: 'Born: ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                                text: split[0],
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    debugPrint('birth year tap');
                                    EasyLoading.show();
                                    getPeopleFromBirthYearApi(split[0])
                                        .then((birthDatePeopleResp) {
                                      pushRoute(
                                          context: context,
                                          screen: PeopleListScreen(
                                              data: PeopleListScreenData(
                                            title: 'People born in ${split[0]}',
                                            ids: birthDatePeopleResp.ids,
                                            count: birthDatePeopleResp.count,
                                            onScrollReallyEnd: (ids) async {
                                              var newResp =
                                                  await getPeopleFromBirthYearApi(
                                                      split[0],
                                                      start: ids.length + 1);
                                              ids.addAll(newResp.ids);
                                            },
                                          )));
                                    });

                                    EasyLoading.dismiss();
                                  }),
                            const TextSpan(text: ' - '),
                            TextSpan(
                                text: birthDate,
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    goToPeopleBornOnThisDateList(
                                        birthDate, context);
                                  }),
                            if (!isBlank(_personResult?.person?.birthPlace))
                              const TextSpan(text: ' in '),
                            if (!isBlank(_personResult?.person?.birthPlace))
                              TextSpan(
                                  text: '${_personResult?.person?.birthPlace}',
                                  style: const TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      goToPeopleBornInThisPlaceList(
                                          _personResult?.person?.birthPlace ??
                                              '',
                                          context);
                                    }),
                          ])),
                          if (!isBlank((_personResult?.person?.deathDate)))
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Died: ',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Expanded(
                                  child: Text(
                                      '${_personResult?.person?.deathDate} in ${_personResult?.person?.deathPlace}'),
                                )
                              ],
                            )
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  ClipRRect _buildPersonAvatar() {
    // debugPrint('small pic = ${smallPic(
    //   _personBean != null &&
    //           _personBean!.person != null &&
    //           _personBean!.person!.avatar != null
    //       ? _personBean!.person!.avatar!
    //       : defaultAvatar,
    // )}');
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 100,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: MyNetworkImage(
            url: smallPic(_personResult?.person?.avatar ?? defaultAvatar),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosCarouselSlider(BuildContext context, List<String> photos) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              //photos
              CarouselSlider.builder(
                  itemCount: photos.length,
                  itemBuilder: ((context, index, realIndex) {
                    return InkWell(
                      onTap: () {
                        _gotoAllPicsScreen(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            // width: screenWidth(context),
                            height: 200,
                            child: MyNetworkImage(
                              url: smallPic(photos[index]),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  options: CarouselOptions(
                      enlargeCenterPage: true, height: 200.0, autoPlay: false)),
            ],
          ),
        ),
        if (PlatformUtils.screenAspectRatio(context) > 1)
          Expanded(child: _buildAvatarAndInfo(context))
      ],
    );
  }

  void _gotoAllPicsScreen(BuildContext context) {
    GoRouter.of(context).pushNamed('/photos',
        extra: AllImagesScreenData(
            imageViewType: ImageViewType.person,
            subjectId: widget.pid,
            title: '${_personResult?.person?.name}'));
  }

  Future<void> _handleShowCommonMovies(
      int index, BuildContext context, List<String> ids) async {
    if (_lockOfCommonMoviesBottomSheet.locked) {
      return;
    }

    try {
      _lockOfCommonMoviesBottomSheet.lock();
      EasyLoading.show(
        status: 'Loading',
      );
      List<String> mids = await _getCommonMids(index, ids);
      EasyLoading.dismiss();

      _showCommonMoviesBottomSheet(context, mids);
    } finally {
      _lockOfCommonMoviesBottomSheet.unlock();
    }
  }

  _showCommonMoviesBottomSheet(BuildContext context, List<String> mids) {
    showCupertinoModalBottomSheet(
        barrierColor: Colors.black87.withOpacity(0.5),
        context: context,
        builder: (context) {
          return SizedBox(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 8.0),
                  child: Text(
                    '${_personResult!.person!.name} and he/she worked together in ${mids.length}  titles',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mids.length,
                    itemBuilder: (BuildContext context, int i) {
                      return PosterCardWrappedLazyLoadBean(
                        id: mids[i],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<List<String>> _getCommonMids(int index, List<String> ids) async {
    List<String> mids = await getCommonMidsApi(widget.pid, ids[index]);
    return mids;
  }

  AwardBean? getAwardBean(MovieOfList movieBean) {
    for (var item in _awards) {
      if (item.movieId == movieBean.id) {
        return item;
      }
    }
    return null;
  }
}

class DidYouKnowDetailScreen extends StatelessWidget {
  const DidYouKnowDetailScreen({
    Key? key,
    required this.person,
  }) : super(key: key);

  final PersonResult? person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Did you know: ${person?.person?.name}'),
      ),
      body: ListView.builder(
        itemCount: person?.person?.didYouKnow?.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: person?.person?.didYouKnow?[index] == null
                  ? const SizedBox()
                  : DidYouKnowItem(
                      didYouKnow: person!.person!.didYouKnow![index]));
        },
      ),
    );
  }
}

class DidYouKnowItem extends StatelessWidget {
  const DidYouKnowItem({
    Key? key,
    required this.didYouKnow,
  }) : super(key: key);

  final DidYouKnow didYouKnow;
  static const titleTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeFirst(didYouKnow.title ?? ''),
          style: titleTextStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          didYouKnow.content!.replaceAll('»', '').trim(),
        ),
      ],
    );
  }
}
