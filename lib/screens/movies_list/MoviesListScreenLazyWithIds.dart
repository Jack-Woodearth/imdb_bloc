import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';

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
  int moviesLoaded = 0;
  Future<NewMovieListRespResult?> future() async {
    var batch =
        idsCopy.sublist(moviesLoaded, min(moviesLoaded + 20, idsCopy.length));

    var newMovieListRespResult = await getNewListMoviesApi(mids: batch);
    moviesLoaded = newMovieListRespResult?.movies?.length ?? 0;
    return newMovieListRespResult;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return MoviesListScreen(
            data: MoviesListScreenData(
                title: widget.name,
                newMovieListRespResult: snapshot.data!..count = count,
                onScrollEnd: () async {
                  var batch2 = idsCopy.sublist(
                      moviesLoaded, min(moviesLoaded + 20, idsCopy.length));
                  dp('batch2=$batch2');

                  var newMovieListRespResult =
                      await getNewListMoviesApi(mids: batch2);
                  moviesLoaded = snapshot.data?.movies?.length ?? 0;

                  dp('onScrollEnd idsCopy.length1= ${idsCopy.length}');
                  if (newMovieListRespResult != null) {
                    snapshot.data?.movies?.addAll(
                        newMovieListRespResult.movies ?? <MovieOfList?>[]);
                  }
                }));
      },
    );
  }
}
