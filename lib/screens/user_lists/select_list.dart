import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/apis/user_lists.dart';
import 'package:imdb_bloc/cubit/user_list_screen_filter_cubit.dart';
import 'package:imdb_bloc/screens/user_lists/add_list.dart';
import 'package:imdb_bloc/screens/user_lists/cubit/select_list_screen_checked_list_cubit.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectListScreen extends StatefulWidget {
  const SelectListScreen({Key? key, required this.subjectId}) : super(key: key);
  final String subjectId;
  @override
  State<SelectListScreen> createState() => _SelectListScreenState();
}

class _SelectListScreenState extends State<SelectListScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  // final SelectListScreenCheckboxController _checkboxController =
  //     Get.put(SelectListScreenCheckboxController());
  final _controller = RefreshController(initialRefresh: true);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var selectListScreenCheckedListCubit =
            SelectListScreenCheckedListCubit();
        getListUrlsContainingSubjectId(widget.subjectId).then((value) {
          dp('getListUrlsContainingSubjectId=$value');
          selectListScreenCheckedListCubit.set(value);
        });
        return selectListScreenCheckedListCubit;
      },
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  pushRoute(context: context, screen: const AddListScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.add),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Create new List...')
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<UserListCubit, UserListState>(
                    builder: (context, state) {
                  // var userLists =
                  //     Get.find<UserListScreenFilterController>().userLists;

                  return SmartRefresher(
                    controller: _controller,
                    enablePullUp: true, //todo
                    // Get.find<UserListScreenFilterController>()
                    //     .hasNextPage
                    //     .value,
                    onLoading: () async {
                      // await Get.find<UserListScreenFilterController>()
                      //     .loadNextPage();//todo
                      _controller.loadComplete();
                    },
                    onRefresh: () async {
                      // await getUserLists();
                      // await Get.find<UserListScreenFilterController>()
                      //     .loadNextPage();//todo
                      _controller.refreshCompleted();
                    },
                    child: ListView.builder(
                      itemCount: state.listUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.subjectId.startsWith('tt') &&
                            state.userLists[index].isPeopleList == true) {
                          return const SizedBox();
                        }
                        if (widget.subjectId.startsWith('nm') &&
                            state.userLists[index].isPeopleList != true) {
                          return const SizedBox();
                        }
                        return InkWell(
                          onTap: () async {
                            // _toggleCheck(
                            //     state.userLists[index].listUrl, context);
                            await _addOrRemove(
                                state.userLists[index].listUrl ?? '', context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  BlocBuilder<SelectListScreenCheckedListCubit,
                                      SelectListScreenCheckedListState>(
                                    builder: (context,
                                        selectListScreenCheckedListState) {
                                      return Checkbox(
                                          value:
                                              selectListScreenCheckedListState
                                                  .urls
                                                  .contains((state
                                                      .userLists[index]
                                                      .listUrl)),
                                          onChanged: (v) async {
                                            // _toggleCheck(
                                            //     state.userLists[index].listUrl,
                                            //     context);
                                            await _addOrRemove(
                                                state.userLists[index]
                                                        .listUrl ??
                                                    '',
                                                context);
                                          });
                                    },
                                  ),
                                  Text(state.userLists[index].listName ?? ''),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    onPressed: () {
                                      var url =
                                          state.userLists[index].listUrl ?? '';

                                      gotoListCreatedByImdbUserScreen(
                                        context,
                                        url,
                                      );
                                    },
                                    icon:
                                        const Icon(Icons.keyboard_arrow_right)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          )),
        );
      }),
    );
  }

  Future<void> _addOrRemove(String url, BuildContext context) async {
    if (isBlank(url)) {
      return;
    }
    var cubit = context.read<SelectListScreenCheckedListCubit>();
    var state = cubit.state;
    var isDelete2 = state.urls.contains((url));
    var success = await addOrRemoveSubjectsToListApi(url, [widget.subjectId],
        isDelete: isDelete2);

    EasyLoading.showSuccess(
        (isDelete2 ? 'Delete' : 'Add') + (success ? ' success' : ' failed'));

    if (isDelete2) {
      cubit.remove(url);
    } else {
      cubit.add(url);
    }
  }

  // void _toggleCheck(String? url, BuildContext context) {
  //   var cubit = context.read<SelectListScreenCheckedListCubit>();
  //   if (!cubit.state.urls.contains(url)) {
  //     if (notBlank(url)) {
  //       cubit.add(url!);
  //     }
  //   } else {
  //     cubit.remove(url ?? '');
  //   }
  // }

  void _getData() async {
    await getUserLists(context);

    var list = await getListUrlsContainingSubjectId(widget.subjectId);
    debugPrint('getListUrlsContainingSubjectId list=$list');
    // _checkboxController.checkedListUrls.addAll(list);
  }
}
