// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../apis/user_lists.dart';
// import '../../beans/list_resp.dart';
// import '../../utils/common.dart';
// import 'add_list.dart';

// class UserListScreen extends StatefulWidget {
//   const UserListScreen({Key? key}) : super(key: key);

//   @override
//   State<UserListScreen> createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   @override
//   void initState() {
//     super.initState();

//     _getData();
//   }

//   final bool _loading = false;
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: true);
//   final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         heroTag: '_UserListScreenState FloatingActionButton',
//         onPressed: () {
//           // Get.to(() => const AddListScreen());//todo
//         },
//         child: const Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         title: const Text("Lists"),
//         actions: [Container()],
//       ),
//       body: (SmartRefresher(
//         controller: _refreshController,
//         onRefresh: () async {
//           await _getData();
//           // setState(() {});
//           if (ctrl.userLists.isEmpty) {
//             await ctrl.loadNextPage();
//           }
//           _refreshController.refreshCompleted();
//           print(
//               '_UserListScreenState SmartRefresher ctrl.userLists.length=${ctrl.userLists.length}');
//         },
//         onLoading: () async {
//           await ctrl.loadNextPage();
//           _refreshController.loadComplete();
//         },
//         enablePullUp: ctrl.hasNextPage.value,
//         child: CustomScrollView(
//           slivers: <Widget>[
//             Obx(() => ListsSliverAppBar(
//                 listName: "Your lists",
//                 infoWidget: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                         '${Get.find<UserListScreenFilterController>().listUrls.length} lists'),
//                     Text(
//                         'List Type: ${Get.find<UserListScreenFilterController>().currentFilters['List Type']}')
//                   ],
//                 ))),
//             SliverAnimatedList(
//                 key: ctrl.listKey,
//                 initialItemCount: ctrl.userLists.length,
//                 itemBuilder: ((context, index, animation) {
//                   var userList = ctrl.userLists[index];
//                   var listType = ctrl.currentFilters['List Type'];

//                   return SizeTransition(
//                     sizeFactor: animation,
//                     child: _buildChild(listType, userList, context, index),
//                   );
//                 })),
//           ],
//         ),
//       )),
//       endDrawer: Drawer(
//         width: screenWidth(context) * 0.6,
//         child: SafeArea(
//             child: Column(
//           children: Get.find<UserListScreenFilterController>()
//               .filters
//               .entries
//               .map((e) {
//             Get.lazyPut(() => ListsEndDrawerFilterGroupShowOptionsController(),
//                 tag: e.key);
//             return ListsEndDrawerFilterGroupWidget(
//               controllerTag: e.key,
//               groupName: e.key,
//               // currentFilterNameWidget: Text(""),
//               currentFilterNameWidget: Obx(() => Text(
//                   Get.find<UserListScreenFilterController>()
//                       .currentFilters[e.key]!)),
//               filterOptionsWidget: Column(
//                 children: Get.find<UserListScreenFilterController>()
//                     .filters[e.key]!
//                     .map((filerValue) => InkWell(
//                           onTap: () {
//                             var find =
//                                 Get.find<UserListScreenFilterController>();
//                             find.currentFilters[e.key] = filerValue;
//                             setState(() {});
//                             debugPrint(
//                                 'currentFilters=${Get.find<UserListScreenFilterController>().currentFilters}');
//                           },
//                           child: ListsEndDrawerFilterItemWidget(
//                             filerValue: filerValue,
//                             checkIconWidget: Obx(() => filerValue ==
//                                     Get.find<UserListScreenFilterController>()
//                                         .currentFilters[e.key]
//                                 ? Icon(
//                                     Icons.check,
//                                     color: imdbYellow,
//                                   )
//                                 : const SizedBox()),
//                           ),
//                         ))
//                     .toList(),
//               ),
//               // onGroupNameTap: () {},
//             );
//           }).toList(),
//         )),
//       ),
//     );
//   }

//   SizedBox _buildChild(
//       String? listType, ListResult userList, BuildContext context, int index) {
//     return SizedBox(
//       // duration: const Duration(milliseconds: 200),
//       // alignment: Alignment.topCenter,
//       child: SizedBox(
//         height: (listType == 'Name' && userList.isPeopleList == true) ||
//                 (listType == 'Title' &&
//                     userList.isPeopleList != true &&
//                     userList.isPictureList != true) ||
//                 listType == 'All'
//             ? null
//             : 0,
//         child: Column(
//           children: [
//             UserListList(
//               // from: '$UserListScreen',
//               userList: userList,
//               onDelete: (_) async {
//                 var scaffoldMessenger = ScaffoldMessenger.of(context);

//                 var deleted = await deleteListApi(userList.listUrl);
//                 if (deleted) {
//                   scaffoldMessenger.showSnackBar(const SnackBar(
//                       behavior: SnackBarBehavior.floating,
//                       content: Text('Deleted')));

//                   // var find = Get.find<UserListScreenFilterController>();
//                   // find.deleteList(userList);
//                   // find.deleteItemAnimation(
//                   //     index, _buildChild(listType, userList, context, index));
//                 }
//               },
//             ),
//             const Divider()
//           ],
//         ),
//       ),
//     );
//   }

//   // List<UserList> userLists = [];
//   // Future<void> _getData() async {
//   //   await getUserLists();
//   // }
// }

// class UserListList extends StatefulWidget {
//   const UserListList({
//     Key? key,
//     required this.userList,
//     required this.onDelete,
//     // this.from,
//   }) : super(key: key);

//   final ListResult userList;
//   final Function(BuildContext) onDelete;
//   // final String? from;
//   @override
//   State<UserListList> createState() => _UserListListState();
// }

// class _UserListListState extends State<UserListList> {
//   @override
//   void initState() {
//     super.initState();
//     // debugPrint('_UserListListState initState');
//     _getData();
//   }

//   @override
//   void didUpdateWidget(covariant UserListList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.userList.listUrl != widget.userList.listUrl) {
//       _getData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       key: GlobalKey(),
//       endActionPane: ActionPane(
//         motion: const ScrollMotion(),
//         children: [
//           SlidableAction(
//             // An action can be bigger than the others.
//             flex: 2,
//             onPressed: widget.onDelete,
//             backgroundColor: const Color.fromARGB(255, 173, 31, 10),
//             foregroundColor: Colors.white,
//             icon: Icons.delete,
//             label: 'Delete',
//           ),
//           // SlidableAction(
//           //   onPressed: (_) {},
//           //   backgroundColor: Color(0xFF0392CF),
//           //   foregroundColor: Colors.white,
//           //   icon: Icons.save,
//           //   label: 'Save',
//           // ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           Get.to(() =>
//               // UserListDetailsScreen(
//               //       // listUrl: widget.userList.listUrl ?? '',
//               //       // title: widget.userList.listName ?? '',
//               //       // isPeopleList: widget.userList.isPeopleList == true,
//               //       listResult: ListResult.fromJson(widget.userList.toJson()),
//               //     ),
//               NewListScreen(listUrl: widget.userList.listUrl ?? ''));
//         },
//         child: SizedBox(
//           width: screenWidth(context),
//           child: Row(
//             children: [
//               SizedBox(
//                   width: 50,
//                   child: MyNetworkImage(
//                     url: _cover ?? defaultCover,
//                   )),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AutoSizeText(
//                         '${widget.userList.listName}',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       AutoSizeText('${widget.userList.listDescription}'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String? _cover = defaultCover;
//   _getData() async {
//     // debugPrint('_UserListListState _getData');

//     // _cover = await getListCoverApi(widget.userList.listUrl ?? '');

//     if (isBlank(widget.userList.cover)) {
//       if (widget.userList.listUrl != null) {
//         var first =
//             (await getListReprImagesApi(widget.userList.listUrl!)).first;
//         if (notBlank(first)) {
//           _cover = first;
//         }
//       }
//     } else {
//       _cover = widget.userList.cover;
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }

// class UserListScreenFilterController extends GetxController {
//   var currentFilters =
//       <String, String>{"Sort By": "Date Modified", "List Type": 'All'}.obs;
//   final filters = <String, List<String>>{
//     "Sort By": ["Date Modified", "Alphabetical"],
//     "List Type": ["All", "Title", "Name"]
//   };
//   var userLists = <ListResult>[].obs;
//   var listUrls = <String>[].obs;
//   var pages = <List<String>>[];
//   int pageIndex = 0;

//   Future<void> loadNextPage() async {
//     if (pageIndex == 0) {
//       hasNextPage.value = true;
//       userLists.value = [];
//     }
//     if (pageIndex >= pages.length) {
//       hasNextPage.value = false;
//       return;
//     }

//     var list = await batchGetListsDetails(pages[pageIndex++]);
//     var oldLength = userLists.length;
//     userLists.addAll(list);
//     for (var i = 0; i < userLists.length - oldLength; i++) {
//       _addItemAnimation(index: oldLength + i);
//     }
//   }

//   var hasNextPage = true.obs;
//   void addList(ListResult list) {
//     userLists.insert(0, list);
//     listUrls.insert(0, list.listUrl!);
//     if (pages.isNotEmpty) {
//       pages.first.add(list.listUrl!);
//     }
//     _addItemAnimation(index: 0);
//   }

//   void deleteList(ListResult list) {
//     userLists.remove(list);
//     for (var page in pages) {
//       if (page.contains(list.listUrl)) {
//         page.remove(list.listUrl);
//         break;
//       }
//     }
//     listUrls.remove(list.listUrl);
//   }

//   final GlobalKey<SliverAnimatedListState> listKey = GlobalKey();

//   void deleteItemAnimation(int index, Widget child) {
//     listKey.currentState?.removeItem(
//         index,
//         (context, animation) => SizeTransition(
//               sizeFactor: animation,
//               child: child,
//             ));
//   }

//   void _addItemAnimation({int index = 0}) {
//     listKey.currentState?.insertItem(index);
//   }
// }

// class UserListListLazy extends StatefulWidget {
//   const UserListListLazy(
//       {Key? key, required this.listUrl, required this.onDelete})
//       : super(key: key);
//   final String listUrl;
//   final Function(BuildContext) onDelete;

//   @override
//   State<UserListListLazy> createState() => _UserListListLazyState();
// }

// class _UserListListLazyState extends State<UserListListLazy>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }

//   @override
//   void didUpdateWidget(UserListListLazy oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.listUrl != widget.listUrl) {
//       _getData();
//     }
//   }

//   ListResult? _userList;
//   _getData() async {
//     var listResp = await getListDetailApi(widget.listUrl);
//     _userList = listResp.result;
//     if (mounted) setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_userList == null) {
//       return const SizedBox(
//           height: 80, child: Center(child: CircularProgressIndicator()));
//     }
//     return UserListList(
//       userList: _userList!,
//       onDelete: widget.onDelete,
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
