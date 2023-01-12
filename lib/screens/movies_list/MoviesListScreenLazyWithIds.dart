import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';

import '../../apis/apis.dart';
import '../../beans/new_list_result_resp.dart';
import '../../utils/list_utils.dart';

class MoviesListScreenLazyWithIds extends StatefulWidget {
  const MoviesListScreenLazyWithIds(
      {super.key, required this.movieIds, required this.name});
  final List<String> movieIds;
  final String name;
  @override
  State<MoviesListScreenLazyWithIds> createState() =>
      _MoviesListScreenLazyWithIdsState();
}

class _MoviesListScreenLazyWithIdsState
    extends State<MoviesListScreenLazyWithIds> {
  late final count = widget.movieIds.length;
  late final idsCopy = widget.movieIds.toList();
  late var batch = firstNOfList(idsCopy, 20);
  Future<NewMovieListRespResult?> future() async {
    var newMovieListRespResult = await getNewListMoviesApi(mids: batch);
    extractFirstNOfList(idsCopy, batch.length);

    return newMovieListRespResult;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MoviesListScreen(
            data: MoviesListScreenData(
                title: widget.name,
                newMovieListRespResult: snapshot.data!..count = count,
                onScrollEnd: () async {
                  var batch2 = firstNOfList(idsCopy, 20);
                  var newMovieListRespResult =
                      await getNewListMoviesApi(mids: batch2);
                  extractFirstNOfList(idsCopy, batch2.length);
                  if (newMovieListRespResult != null) {
                    snapshot.data?.movies?.addAll(
                        newMovieListRespResult.movies ?? <MovieOfList?>[]);
                  }
                }));
      },
    );
  }
}
