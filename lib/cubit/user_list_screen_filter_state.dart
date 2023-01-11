part of 'user_list_screen_filter_cubit.dart';

@immutable
abstract class UserListState {
  final filters = <String, List<String>>{
    "Sort By": ["Date Modified", "Alphabetical"],
    "List Type": ["All", "Title", "Name"]
  };
  final List<ListResult> userLists;
  final List<String> listUrls;
  final List<List<String>> pages;
  final int pageIndex;
  final Map<String, String> currentFilters;
  final bool hasNextPage;
  UserListState(
      {required this.hasNextPage,
      required this.userLists,
      required this.listUrls,
      required this.pages,
      required this.currentFilters,
      required this.pageIndex});

  UserListState copyWith({
    List<ListResult>? userLists,
    List<String>? listUrls,
    List<List<String>>? pages,
    int? pageIndex,
    Map<String, String>? currentFilters,
    bool? hasNextPage,
  });
}

class UserListScreenFilterInitial extends UserListState {
  UserListScreenFilterInitial(
      {super.userLists = const [],
      super.hasNextPage = false,
      super.listUrls = const [],
      super.pages = const [],
      super.currentFilters = const {
        "Sort By": "Date Modified",
        "List Type": 'All'
      },
      super.pageIndex = 0});

  @override
  UserListState copyWith(
      {List<ListResult>? userLists,
      List<String>? listUrls,
      List<List<String>>? pages,
      int? pageIndex,
      bool? hasNextPage,
      Map<String, String>? currentFilters}) {
    return UserListScreenFilterInitial();
  }
}

class UserListScreenFilterNormal extends UserListState {
  UserListScreenFilterNormal(
      {required super.userLists,
      required super.hasNextPage,
      required super.listUrls,
      required super.pages,
      required super.currentFilters,
      required super.pageIndex});

  @override
  UserListState copyWith({
    List<ListResult>? userLists,
    List<String>? listUrls,
    List<List<String>>? pages,
    int? pageIndex,
    Map<String, String>? currentFilters,
    bool? hasNextPage,
  }) {
    return UserListScreenFilterNormal(
        userLists: userLists ?? this.userLists,
        listUrls: listUrls ?? this.listUrls,
        pages: pages ?? this.pages,
        pageIndex: pageIndex ?? this.pageIndex,
        currentFilters: currentFilters ?? this.currentFilters,
        hasNextPage: hasNextPage ?? this.hasNextPage);
  }
}
