import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:group_button/group_button.dart';
import 'package:imdb_bloc/apis/search_apis.dart';
import 'package:imdb_bloc/screens/home/top_titles.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_details_screen_lazyload.dart';
import 'package:imdb_bloc/screens/person/person_detail_screen.dart';
import 'package:imdb_bloc/screens/search_result/cubit/search_history_cubit.dart';
import 'package:imdb_bloc/screens/search_result/search_result_screen.dart';
import 'package:imdb_bloc/utils/common.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../beans/people_suggest_resp.dart';
import '../../beans/search_suggest_bean.dart';
import '../../constants/colors_constants.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_group_buttons.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  String _query = '';
  bool _shouldSearchPeople = false;
  final peopleStreamController =
      StreamController<List<PersonSuggestBean>?>.broadcast();
  final moviesStreamController =
      StreamController<List<SearchMovieSuggestBean>?>.broadcast();

  int _tabIndex = 0;
  static const key = 'ashdhkajsdk';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var searchHistoryCubit = SearchHistoryCubit();
        SharedPreferences.getInstance().then((value) {
          var string = value.getString(key);
          searchHistoryCubit.set(deSerializeHistoryItems(string));
        });
        return searchHistoryCubit;
      },
      child: Builder(builder: (context) {
        return Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 35),
              child: TopTitles(),
            ),
            Focus.withExternalFocusNode(
                focusNode: _focusNode,
                child: FloatingSearchBar(
                  onFocusChanged: (hasFocus) {
                    // Get.find<FloatingSearchBarIconCtrl>().setIsClosed(!hasFocus);//todo
                    setState(() {});
                  },
                  backgroundColor: Theme.of(context).cardColor,
                  isScrollControlled: true,
                  transitionDuration: const Duration(milliseconds: 200),
                  implicitDuration: const Duration(milliseconds: 200),
                  controller: _floatingSearchBarController,
                  onQueryChanged: (v) async {
                    _query = v;

                    if (_shouldSearchPeople) {
                      var list = await suggestPeopleApi(_query);
                      peopleStreamController.add(list);
                    } else {
                      var list = await suggestMoviesApi(_query);
                      moviesStreamController.add(list);
                    }
                  },
                  onSubmitted: (value) async {
                    _query = value;
                    if (_query == '') {
                      EasyLoading.showError('Query is empty');
                      return;
                    }

                    pushRoute(
                        context: context,
                        screen: SearchResultScreen(
                            query: _query,
                            shouldSearchPeople: _shouldSearchPeople));
                    var read = context.read<SearchHistoryCubit>();
                    read.addItem(Item(
                        isPeople: _shouldSearchPeople,
                        name: value,
                        timeMilliseconds:
                            DateTime.now().millisecondsSinceEpoch));
                    SharedPreferences.getInstance().then((value) =>
                        value.setString(
                            key,
                            jsonEncode(
                                serializeHistoryItems(read.state.items))));
                  },
                  actions: [
                    GestureDetector(
                      child: Icon(_floatingSearchBarController.isClosed
                          ? Icons.search
                          : Icons.close),
                      onTap: () {
                        // _onSearch();
                        if (_floatingSearchBarController.isClosed) {
                          _floatingSearchBarController.open();
                        } else {
                          if (isBlank(_floatingSearchBarController.query)) {
                            // Get.back();
                            _floatingSearchBarController.close();
                          } else {
                            _floatingSearchBarController.clear();
                          }
                        }
                      },
                    )
                  ],
                  physics: const NeverScrollableScrollPhysics(),
                  // hint: _hintCtrl.hint.value,
                  builder: (context, transition) {
                    return _buildSearchBarBody();
                  },
                )),
          ],
        );
      }),
    );
  }

  ClipRRect _buildSearchBarBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
          elevation: 4.0,
          child: SizedBox(
            child: Column(
              children: [
                MyGroupButton(
                  buttons: const ['Title', 'Name'],
                  onSelected: (_, index, __) async {
                    _shouldSearchPeople = index == 1;
                    setState(() {});
                  },
                  controller: GroupButtonController(
                      selectedIndex: _shouldSearchPeople ? 1 : 0),
                ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  onTap: (v) {
                    _tabIndex = v;
                    setState(() {});
                  },
                  tabs: const [
                    Tab(
                      text: 'Suggested',
                    ),
                    Tab(
                      text: 'History',
                    ),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: MaterialIndicator(
                      bottomRightRadius: 5,
                      bottomLeftRadius: 5,
                      color: imdbYellow),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _tabIndex,
                    children: [
                      if (_shouldSearchPeople)
                        StreamBuilder<List<PersonSuggestBean>?>(
                            stream: peopleStreamController.stream,
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (data != null) {
                                          pushRoute(
                                              context: context,
                                              screen: PersonDetailScreen(
                                                  pid: data.id));
                                          context
                                              .read<SearchHistoryCubit>()
                                              .addItem(Item(
                                                  id: data.id,
                                                  name: data.name,
                                                  timeMilliseconds: DateTime
                                                          .now()
                                                      .millisecondsSinceEpoch,
                                                  isPeople:
                                                      _shouldSearchPeople));
                                        }
                                      },
                                      child: ListTile(
                                        title: Text('${data?.name}'),
                                      ),
                                    );
                                  });
                            })
                      else
                        StreamBuilder<List<SearchMovieSuggestBean>?>(
                            stream: moviesStreamController.stream,
                            builder: (_, snapshot) {
                              return ListView.builder(
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (data != null) {
                                          context
                                              .read<SearchHistoryCubit>()
                                              .addItem(Item(
                                                  id: data.mid,
                                                  name: data.title,
                                                  timeMilliseconds: DateTime
                                                          .now()
                                                      .millisecondsSinceEpoch,
                                                  isPeople:
                                                      _shouldSearchPeople));
                                          pushRoute(
                                              context: context,
                                              screen:
                                                  MovieFullDetailScreenLazyLoad(
                                                      mid: data.mid));
                                        }
                                      },
                                      child: ListTile(
                                        title: Text('${data?.title}'),
                                      ),
                                    );
                                  });
                            }),
                      Column(
                        children: [
                          Expanded(
                            child: BlocBuilder<SearchHistoryCubit,
                                SearchHistoryState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state.items.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              var id = state.items[index].id;
                                              if (id != null) {
                                                if (id.startsWith('tt')) {
                                                  pushRoute(
                                                      context: context,
                                                      screen:
                                                          MovieFullDetailScreenLazyLoad(
                                                              mid: id));
                                                } else if (id
                                                    .startsWith('nm')) {
                                                  pushRoute(
                                                      context: context,
                                                      screen:
                                                          PersonDetailScreen(
                                                              pid: id));
                                                }
                                              } else {
                                                pushRoute(
                                                    context: context,
                                                    screen: SearchResultScreen(
                                                        query: state
                                                            .items[index].name,
                                                        shouldSearchPeople:
                                                            state.items[index]
                                                                .isPeople));
                                              }
                                            },
                                            child: ListTile(
                                              title:
                                                  Text(state.items[index].name),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: state.items.isEmpty
                                            ? null
                                            : () {
                                                showConfirmDialog(context,
                                                    "Clear search history?",
                                                    () {
                                                  context
                                                      .read<
                                                          SearchHistoryCubit>()
                                                      .empty();
                                                  SharedPreferences
                                                          .getInstance()
                                                      .then((value) =>
                                                          value.remove(key));
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                        child: const Text('Clear history'))
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )),
    );
  }
}
