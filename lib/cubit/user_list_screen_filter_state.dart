part of 'user_list_screen_filter_cubit.dart';

@immutable
class UserListState {
  static final filters = <String, List<String>>{
    "Sort By": ["Date Modified", "Alphabetical"],
    "List Type": ["All", "Title", "Name"]
  };
  final List<ListResult> userLists;
  final List<String> listUrls;
  final List<List<String>> pages;
  final int pageIndex;
  final Map<String, String> currentFilters;
  final bool hasNextPage;
  final List<String> checkedUrls;
  const UserListState(
      {required this.hasNextPage,
      required this.checkedUrls,
      required this.userLists,
      required this.listUrls,
      required this.pages,
      required this.currentFilters,
      required this.pageIndex});

  UserListState copyWith(
      {List<ListResult>? userLists,
      List<String>? listUrls,
      List<List<String>>? pages,
      int? pageIndex,
      Map<String, String>? currentFilters,
      bool? hasNextPage,
      List<String>? checkedUrls}) {
    return UserListState(
        userLists: userLists ?? this.userLists,
        listUrls: listUrls ?? this.listUrls,
        pages: pages ?? this.pages,
        pageIndex: pageIndex ?? this.pageIndex,
        currentFilters: currentFilters ?? this.currentFilters,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        checkedUrls: checkedUrls ?? this.checkedUrls);
  }
}

class UserListInitialState extends UserListState {
  UserListInitialState()
      : super(
            userLists: [],
            listUrls: [],
            pages: [],
            pageIndex: 0,
            currentFilters: UserListState.filters
                .map((key, value) => MapEntry(key, value.first)),
            hasNextPage: false,
            checkedUrls: []);
}
