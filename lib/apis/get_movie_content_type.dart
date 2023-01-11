import 'package:imdb_bloc/beans/details.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/sp/sp_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apis.dart';

Future<MovieDetailsResp?> getMoviesTypeApi(List<String> ids) async {
  final key = 'getMoviesTypeApi$ids';
  var preferences = await SharedPreferences.getInstance();
  final movies = <MovieBean>[];
  final idsToGetFromServer = <String>[];
  for (var id in ids) {
    final keyOfId = 'contenty_type:$id';
    var string = preferences.getString(keyOfId);
    if (string != null) {
      movies.add(MovieBean(id: id, contentType: string));
    } else {
      idsToGetFromServer.add(id);
    }
  }
  if (idsToGetFromServer.isEmpty) {
    return MovieDetailsResp(code: 200, result: movies);
  }
  // var ret = await SpCache.wrapped(
  //     MovieDetailsResp.fromJson, actualGetMoviesTypeApi, [ids],
  //     timeout: const Duration(days: 365));
  var ret = await actualGetMoviesTypeApi(idsToGetFromServer);
  for (var element in ret?.result ?? <MovieBean>[]) {
    final keyOfId = 'contenty_type:${element.id}';

    preferences.setString(keyOfId, element.contentType ?? 'Other');
  }
  ret?.result?.addAll(movies);
  return ret;
}

Future<MovieDetailsResp?> actualGetMoviesTypeApi(List<String> ids) =>
    getMovieDetailsApi(ids, fields: ['content_type']);
