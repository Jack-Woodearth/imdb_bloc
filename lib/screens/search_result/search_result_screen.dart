import 'package:flutter/material.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';
import 'package:imdb_bloc/screens/people_screen/person_list_screen.dart';

import '../../apis/apis.dart';
import '../../apis/name_search.dart';
import '../../beans/new_list_result_resp.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen(
      {super.key, required this.query, required this.shouldSearchPeople});
  final String query;
  final bool shouldSearchPeople;
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  NameSearchResult? nameSearchResult;
  NewMovieListRespResult? movieListRespResult;
  int moviePage = 1;
  int peoplePage = 1;
  bool movieEnd = false;
  bool peopleEnd = false;
  @override
  void initState() {
    super.initState();
    search();
  }

  Future<void> search() async {
    if (widget.shouldSearchPeople) {
      nameSearchResult = await nameSearch(widget.query);
      // print(nameSearchResult);
    } else {
      movieListRespResult = await simpleSearchApi(widget.query);
      // print(movieListRespResult);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Search result of ${widget.query}';
    return widget.shouldSearchPeople
        ? PeopleListScreen(
            data: PeopleListScreenData(
                onScrollReallyEnd: (p0) async {
                  if (peopleEnd) {
                    return;
                  }
                  var newNameSearchResult =
                      await nameSearch(widget.query, page: ++peoplePage);
                  p0.addAll(newNameSearchResult.ids);
                  peopleEnd = newNameSearchResult.ids.isEmpty;
                  setState(() {});
                },
                title: title,
                ids: nameSearchResult?.ids ?? [],
                count: nameSearchResult?.count ?? 0))
        : movieListRespResult == null
            ? const SizedBox()
            : MoviesListScreen(
                data: MoviesListScreenData(
                title: title,
                newMovieListRespResult: movieListRespResult!,
                onScrollEnd: () async {
                  if (movieEnd) {
                    return;
                  }
                  var newMovieListRespResult =
                      await simpleSearchApi(widget.query, page: ++moviePage);
                  var iterable =
                      newMovieListRespResult?.movies ?? <MovieOfList?>[];
                  movieEnd == iterable.isEmpty;
                  movieListRespResult?.movies?.addAll(iterable);
                  setState(() {});
                },
              ));
  }
}
