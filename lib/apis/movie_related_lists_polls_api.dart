import 'package:imdb_bloc/utils/debug_utils.dart';

import '../beans/movie_related_lists_polls.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<MovieRelatedListsPolls?> getMovieRelatedListsPollsApi(String mid) async {
  dp('getMovieRelatedListsPollsAp $mid');
  var path = '$baseUrl/related_lists_polls/$mid';
  var data = await MyDio().get(path);
  return MovieRelatedListsPollsResp.fromJson(data).result;
}
