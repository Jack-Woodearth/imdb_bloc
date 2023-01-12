import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/beans/person_detail_resp.dart';
import 'package:imdb_bloc/cubit/favlist_count_cubit.dart';
import 'package:imdb_bloc/cubit/filter_button_cubit.dart';
import 'package:imdb_bloc/cubit/user_recently_viewed_cubit.dart';
import 'package:imdb_bloc/cubit/theme_mode_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_galleries_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';
import 'package:imdb_bloc/cubit/user_list_screen_filter_cubit.dart';
import 'package:imdb_bloc/cubit/user_rated_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/screens/settings/settings_home.dart';
import 'package:imdb_bloc/screens/signin/imdb_signin.dart';
import 'package:imdb_bloc/screens/user_lists/add_list.dart';
import 'package:imdb_bloc/screens/user_lists/user_lists_screen.dart';
import 'package:imdb_bloc/screens/user_profile/user_fav_lists_card.dart';
import 'package:imdb_bloc/screens/user_profile/user_lists_card.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:imdb_bloc/widgets/PosterCardWrappedLazyLoadBean.dart';
import 'package:imdb_bloc/widgets/filter_buttons.dart';
import 'package:imdb_bloc/widgets/movie_poster_card.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

import '../../apis/apis.dart';
import '../../apis/fav_lists.dart';
import '../../apis/user_lists.dart';
import '../../beans/list_resp.dart';
import '../../enums/enums.dart';
import '../../singletons/user.dart';
import '../../utils/common.dart';
import '../../utils/list_utils.dart';
import '../../utils/theme_utils.dart';
import '../../widgets/RelatedGalleryWidget.dart';
import '../../widgets/StackedPictures.dart';
import '../../widgets/TitleAndSeeAll.dart';
import '../../widgets/UserListList.dart';
import '../../widgets/imdb_button.dart';
import '../all_images/all_images.dart';
import 'user_rated_titles_card.dart';
import 'utils/you_screen_utils.dart';

class YouScreen extends StatefulWidget {
  const YouScreen({Key? key}) : super(key: key);

  @override
  State<YouScreen> createState() => _YouScreenState();
}

class _YouScreenState extends State<YouScreen> {
  final double personSize = 25;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  final String tag = 'YouScreen';

  Future _getData() async {
    debugPrint('_YouScreenState_getData');
    getFavListsCount(context.read<FavListCountCubit>());
  }

  final _cardHeight = 200.0;
  final _tagRatedTitles = const Uuid().v4();
  final _tagFavPics = const Uuid().v4();
  final RefreshController _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        await _getData();
        _refreshController.refreshCompleted();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate(
              [
                // top
                Builder(
                  builder: (_) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(personSize / 2),
                              child: Container(
                                  width: personSize,
                                  height: personSize,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5),
                                  child: const Icon(
                                    Icons.person_rounded,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocBuilder<UserCubit, User>(
                                builder: (context, user) {
                                  return Text(
                                    //todo
                                    user.isLogin ? user.username : 'Sign in ',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            StatefulBuilder(builder: (context, update) {
                              return IconButton(onPressed: () {
                                toggleTheme(context);
                                update(() {});
                              }, icon: BlocBuilder<ThemeModeCubit, ThemeMode>(
                                builder: (context, state) {
                                  return Icon(state == ThemeMode.dark
                                      ? Icons.sunny
                                      : Icons.dark_mode);
                                },
                              ));
                            }),
                            IconButton(
                                onPressed: () {
                                  pushRoute(
                                      context: context,
                                      screen: const SettingsHomeScreen());
                                },
                                icon: const Icon(Icons.settings_outlined)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Welcome!',
                    maxLines: 3,
                  ),
                ),

// Sign in
                BlocBuilder<UserCubit, User>(
                  builder: (context, state) {
                    return !state.isLogin
                        ? ImdbButton(
                            text: 'Sign in / Sign up',
                            onTap: () {
                              pushRoute(
                                  context: context,
                                  screen: const ImdbSignInScreen());
                            },
                          )
                        : const SizedBox();
                  },
                ),
                // cards
                SizedBox(
                  height: _cardHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: BlocBuilder<UserCubit, User>(
                      builder: (context, user) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            UserListsCardOnYouScreen(
                              cardHeight: _cardHeight,
                            ),

                            //fav lists card
                            if (user.isLogin)
                              InkWell(
                                onTap: () async {
                                  //todo
                                  // Get.to(() => const FavListsWidget());
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Builder(builder: (_) {
                                        return Column(
                                          children: [
                                            Expanded(
                                              child: UserFavListCard(
                                                  tag: tag,
                                                  cardHeight: _cardHeight),
                                            ),
                                            const UserFavListsCountWidget(),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),

                            if (user.isLogin)
                              UserFavGalleriesWidget(
                                cardHeight: _cardHeight,
                              ),

                            if (user.isLogin)
                              InkWell(
                                onTap: () {
                                  //todo
                                  // Get.to(() => Obx(() => LongMovieListWrapper(
                                  //     ids: Get.find<UserRatedTitlesController>()
                                  //         .titles
                                  //         .map((element) => element.mid!)
                                  //         .toList(),
                                  //     title: 'My rated titles')));
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  child: BlocBuilder<UserRatedCubit,
                                      UserRatedState>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: UserRatedTitlesCard(
                                              tag: _tagRatedTitles,
                                              cardHeight: _cardHeight,
                                              titles: state.titles,
                                            ),
                                          ),
                                          Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${state.titles.length} rated titles'),
                                          )),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),

                            if (user.isLogin)
                              Builder(builder: (context) {
                                const title2 = 'Favorite photos';

                                return GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).pushNamed('/photos',
                                        extra: const AllImagesScreenData(
                                            imageViewType:
                                                ImageViewType.userFavorite,
                                            subjectId: '',
                                            title: title2));
                                  },
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: BlocBuilder<UserFavPhotosCubit,
                                              UserFavPhotosState>(
                                            builder:
                                                (BuildContext context, state) {
                                              var list = state.photos
                                                  .map((e) => e.photoUrl ?? '')
                                                  .toList();
                                              return list.isNotEmpty
                                                  ? ListsCoversStackPictures(
                                                      pictures:
                                                          firstNOfList(list, 3),
                                                      tag: _tagFavPics)
                                                  : const SizedBox();
                                            },
                                          ),
                                        ),
                                        const Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(title2),
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          ]
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: _cardHeight,
                                      width: _cardHeight,
                                      child: e,
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
//watch list
                BlocBuilder<UserWatchListCubit, UserWatchListState>(
                  builder: (context, state) {
                    return TitleAndSeeAll(
                        title: 'Watch list',
                        label: '${state.movies.length}',
                        onTap: () {});
                  },
                ),
                BlocProvider(
                  create: (context) => FilterButtonCubit(),
                  child: Column(
                    children: [
                      FilterButtons(
                        tag: tag,
                        btnNamesToExclude: const [BtnNames.type],
                        onFilterChanged: () {},
                      ),
                      SizedBox(
                        height: 250,
                        child:
                            BlocBuilder<FilterButtonCubit, FilterButtonState>(
                          builder: (context, filterButtonState) {
                            return BlocBuilder<UserWatchListCubit,
                                UserWatchListState>(
                              builder: (context, state) {
                                return state.movies.isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        itemCount: state.movies.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return AnimatedSize(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: SizedBox(
                                              width: filtered(
                                                      filterButtonState,
                                                      state.movies[index]
                                                          .movieBean)
                                                  ? null
                                                  : 0,
                                              child: PosterCard(
                                                  posterUrl: state.movies[index]
                                                          .movieBean.cover ??
                                                      '',
                                                  title: state.movies[index]
                                                          .movieBean.title ??
                                                      '',
                                                  id: state.movies[index]
                                                      .movieBean.id),
                                            ),
                                          );
                                        },
                                      );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //fav people
                BlocBuilder<UserFavPeopleCubit, UserFavPeopleState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        TitleAndSeeAll(
                            title: 'Favorite people',
                            label: '${state.people.length}',
                            onTap: () {}),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.people.length,
                            itemBuilder: (BuildContext context, int index) {
                              var person = state.people[index];
                              return PosterCard(
                                  posterUrl: person.personBean.image,
                                  title: person.personBean.title ?? '',
                                  id: person.personBean.id!);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                BlocBuilder<UserRecentlyViewedCubit, UserRecentlyViewedState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        TitleAndSeeAll(
                            title: 'Recently viewed',
                            label: '${state.recentViewedBeans.length}',
                            onTap: () {}),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.recentViewedBeans.length,
                            itemBuilder: (BuildContext context, int index) {
                              var bean = state.recentViewedBeans[index];
                              return PosterCardWrappedLazyLoadBean(
                                  id: bean.mid!);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class FavListsWidget extends StatefulWidget {
  const FavListsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FavListsWidget> createState() => _FavListsWidgetState();
}

class _FavListsWidgetState extends State<FavListsWidget> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My favorite lists'),
      ),
      body: Card(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              // height: 200,
              width: screenWidth(context),
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  _pageIndex = 0;
                  await _getPageDetails();
                  _refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await _getPageDetails();
                  _refreshController.loadComplete();
                },
                enablePullUp: _pageIndex < _pages.length,
                child: ListView.builder(
                  itemCount: _lists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 80, //todo
                          // _listShowControl[index].show ? null : 0,
                          child: UserListList(
                            // listUrl: _listShowControl[index].listUrl,
                            onDelete: (ctx) async {
                              // var success = await deleteFavListApi(
                              //     _listShowControl[index].listUrl);
                              // if (success) {
                              //   // _getData();
                              //   _listShowControl[index].show = false;
                              //   if (mounted) {
                              //     setState(() {});
                              //   }
                              //   getFavListCountApi();
                              //   ScaffoldMessenger.maybeOf(context)
                              //       ?.showSnackBar(SnackBar(
                              //           content: Row(
                              //     children: [
                              //       const Expanded(
                              //           child:
                              //               Text('List removed from favorite')),
                              //       TextButton(
                              //         onPressed: () async {
                              //           var added = await addFavListApi(
                              //               _listShowControl[index].listUrl);
                              //           getFavListCountApi();
                              //           _listShowControl[index].show = true;
                              //           ScaffoldMessenger.maybeOf(context)
                              //               ?.removeCurrentSnackBar();
                              //           if (mounted) {
                              //             setState(() {});
                              //           }
                              //         },
                              //         child: const Text(
                              //           'undo',
                              //           style: TextStyle(color: Colors.blue),
                              //         ),
                              //       ),
                              //     ],
                              //   )));
                              // }
                            },
                            userList: _lists[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  List<ListResult> _lists = [];
  List<List<String>> _pages = [];
  int _pageIndex = 0;
  // var _listShowControl = <ListsShowControl>[];
  Future<void> _getPageDetails() async {
    if (_pageIndex == 0) {
      _lists = [];
    }
    if (_pageIndex == _pages.length) {
      return;
    }
    _lists.addAll(await batchGetListsDetails(_pages[_pageIndex++]));
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getData() async {
    EasyLoading.show();
    var listUrls = await getFavListsApi();
    _pages = splitList(listUrls, 7);

    // _listShowControl =
    //     _listUrls.map((e) => ListsShowControl(listUrl: e)).toList();
    _pageIndex = 0;
    _getPageDetails();
    EasyLoading.dismiss();

    // if (mounted) {
    //   setState(() {});
    // }
  }
}

class UserFavGalleriesWidget extends StatelessWidget {
  const UserFavGalleriesWidget({
    Key? key,
    required this.cardHeight,
  }) : super(key: key);
  final _tag = '45645612454654654156165';
  final double cardHeight;
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Theme.of(context).cardColor,
      openColor: Theme.of(context).cardColor,
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: ((context, action) =>
          BlocBuilder<UserFavGalleriesCubit, List<String>>(
            builder: (context, state) {
              return FutureBuilder(
                future:
                    getGalleriesCovers(state.sublist(0, min(state.length, 3))),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  return snapshot.hasData
                      ? Column(
                          children: [
                            Expanded(
                              child: ListsCoversStackPictures(
                                  pictures: snapshot.data ?? [], tag: _tag),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '${snapshot.data?.length} favorite galleries'),
                            ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator());
                },
              );
            },
          )),
      openBuilder: (context, action) => SafeArea(
        child: SizedBox(
          height: 600,
          child: BlocBuilder<UserFavGalleriesCubit, List<String>>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.length,
                itemBuilder: (BuildContext context, int index) {
                  var gid2 = state[index];
                  return GalleryCard(gid: gid2);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class GalleryCard extends StatelessWidget {
  const GalleryCard({
    Key? key,
    required this.gid,
  }) : super(key: key);

  final String gid;

  @override
  Widget build(BuildContext context) {
    return RelatedGalleryWidget(
      gid: gid,
    );
  }
}

class UserListsCardOnYouScreen extends StatefulWidget {
  const UserListsCardOnYouScreen({
    Key? key,
    required this.cardHeight,
  }) : super(key: key);

  @override
  State<UserListsCardOnYouScreen> createState() =>
      _UserListsCardOnYouScreenState();
  final double cardHeight;
}

class _UserListsCardOnYouScreenState extends State<UserListsCardOnYouScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant UserListsCardOnYouScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final _tag = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          pushRoute(context: context, screen: const UserListScreen());
          //todo
          // if (Get.find<UserListScreenFilterController>().listUrls.isNotEmpty) {
          //   Get.to(() => const UserListScreen());
          // }
          // pushRoute(context: context, screen: userlissc)
        },
        child: Column(children: [
          Expanded(
            child: BlocBuilder<UserListCubit, UserListState>(
              builder: (context, state) => (state.listUrls.isEmpty)
                  ? Center(
                      child: CupertinoButton(
                          onPressed: () {
                            pushRoute(
                                context: context,
                                screen: const AddListScreen());
                          },
                          child: const Text('Create a list')))
                  : UserListsCard(
                      listUrls: state.listUrls,
                      tag: _tag,
                      cardHeight: widget.cardHeight),
            ),
          ),
          BlocBuilder<UserCubit, User>(
            builder: (context, state) {
              return state.isLogin
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<UserListCubit, UserListState>(
                        builder: (context, state) {
                          return Text(
                              '${state.listUrls.length} lists created by me');
                        },
                      ),
                    )
                  : const SizedBox();
            },
          )
        ]),
      ),
    );
  }

  // List<UserList> _list = [];
  Future<void> _getData() async {
    // await getUserLists(context);
  }
}

class ListsCoversStackPictures extends StatelessWidget {
  const ListsCoversStackPictures({
    Key? key,
    required this.tag,
    required this.pictures,
  }) : super(key: key);
  final String tag;
  final List<String> pictures;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        return StackedPictures(
          pictures: pictures,
        );
      },
    );
  }
}
