import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/user_list_screen_filter_cubit.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../apis/user_lists.dart';
import '../../beans/list_resp.dart';
import '../../widgets/UserListList.dart';
import 'add_list.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();

    // _getData();
  }

  final bool _loading = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  final _canPullUp = true;
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: '_UserListScreenState FloatingActionButton',
        onPressed: () {
          pushRoute(context: context, screen: const AddListScreen());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Lists"),
        actions: [Container()],
      ),
      body: (SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          //todo
          // await _getData();
          // setState(() {});
          // if (ctrl.userLists.isEmpty) {
          //   await ctrl.loadNextPage();
          // }
          _refreshController.refreshCompleted();
          // print(
          //     '_UserListScreenState SmartRefresher ctrl.userLists.length=${ctrl.userLists.length}');
        },
        onLoading: () async {
          // await ctrl.loadNextPage();//todo
          _refreshController.loadComplete();
        },
        enablePullUp: _canPullUp,
        child: CustomScrollView(
          slivers: <Widget>[
            ListsSliverAppBar(
                listName: "Your lists",
                infoWidget: BlocBuilder<UserListCubit, UserListState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${state.listUrls.length} lists'),
                        Text('List Type: ${state.currentFilters['List Type']}')
                      ],
                    );
                  },
                )),
            BlocBuilder<UserListCubit, UserListState>(
              builder: (context, state) {
                return SliverList(
                  key: _key,
                  delegate: SliverChildBuilderDelegate(((context, index) {
                    var userList = state.userLists[index];
                    var listType = state.currentFilters['List Type'];

                    return _buildChild(listType, userList, context, index);
                  }), childCount: state.userLists.length),
                  // initialItemCount: state.userLists.length,1
                );
              },
            ),
          ],
        ),
      )),
      // endDrawer: Drawer(
      //   width: screenWidth(context) * 0.6,
      //   child: SafeArea(
      //       child: Column(
      //     children:
      //         context.read<UserListCubit>().state.filters.entries.map((e) {
      //       return ListsEndDrawerFilterGroupWidget(
      //         controllerTag: e.key,
      //         groupName: e.key,
      //         // currentFilterNameWidget: Text(""),
      //         currentFilterNameWidget: Obx(() => Text(
      //             Get.find<UserListScreenFilterController>()
      //                 .currentFilters[e.key]!)),
      //         filterOptionsWidget: Column(
      //           children: Get.find<UserListScreenFilterController>()
      //               .filters[e.key]!
      //               .map((filerValue) => InkWell(
      //                     onTap: () {
      //                       var find =
      //                           Get.find<UserListScreenFilterController>();
      //                       find.currentFilters[e.key] = filerValue;
      //                       setState(() {});
      //                       debugPrint(
      //                           'currentFilters=${Get.find<UserListScreenFilterController>().currentFilters}');
      //                     },
      //                     child: ListsEndDrawerFilterItemWidget(
      //                       filerValue: filerValue,
      //                       checkIconWidget: Obx(() => filerValue ==
      //                               Get.find<UserListScreenFilterController>()
      //                                   .currentFilters[e.key]
      //                           ? Icon(
      //                               Icons.check,
      //                               color: imdbYellow,
      //                             )
      //                           : const SizedBox()),
      //                     ),
      //                   ))
      //               .toList(),
      //         ),
      //         // onGroupNameTap: () {},
      //       );
      //     }).toList(),
      //   )),
      // ),
      //todo
    );
  }

  SizedBox _buildChild(
      String? listType, ListResult userList, BuildContext context, int index) {
    return SizedBox(
      child: SizedBox(
        height: (listType == 'Name' && userList.isPeopleList == true) ||
                (listType == 'Title' &&
                    userList.isPeopleList != true &&
                    userList.isPictureList != true) ||
                listType == 'All'
            ? null
            : 0,
        child: Column(
          children: [
            UserListList(
              userList: userList,
              onDelete: (_) async {
                var scaffoldMessenger = ScaffoldMessenger.of(context);

                var deleted = await deleteListApi(userList.listUrl);
                if (deleted) {
                  scaffoldMessenger.showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Deleted')));
                  context.read<UserListCubit>().remove(userList.listUrl ?? '');
                }
              },
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  // List<UserList> userLists = [];
  // Future<void> _getData() async {
  //   await getUserLists();
  // }
}

class UserListListLazy extends StatefulWidget {
  const UserListListLazy(
      {Key? key, required this.listUrl, required this.onDelete})
      : super(key: key);
  final String listUrl;
  final Function(BuildContext) onDelete;

  @override
  State<UserListListLazy> createState() => _UserListListLazyState();
}

class _UserListListLazyState extends State<UserListListLazy>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(UserListListLazy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listUrl != widget.listUrl) {
      _getData();
    }
  }

  ListResult? _userList;
  _getData() async {
    var listResp = await getListDetailApi(widget.listUrl);
    _userList = listResp.result;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_userList == null) {
      return const SizedBox(
          height: 80, child: Center(child: CircularProgressIndicator()));
    }
    return UserListList(
      userList: _userList!,
      onDelete: widget.onDelete,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ListsSliverAppBar extends StatelessWidget {
  const ListsSliverAppBar({
    Key? key,
    required this.infoWidget,
    required this.listName,
  }) : super(key: key);
  final Widget infoWidget;
  final String listName;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false, // this will hide Drawer hamburger icon
      actions: <Widget>[Container()],
      floating: true,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listName),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoWidget,
                    // _buildResultsCountAndSortBy(),
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Material(child: Icon(Icons.sort)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
