import '../beans/imdb_user.dart';
import '../beans/new_list_result_resp.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<ImdbUserBean?> getImdbUserApi(String uid) async {
  var response = await MyDio().dio.get(baseUrl + '/imdb_user/$uid');
  return ImdbUserResp.fromJson(response.data).result;
}

Future<ImdbUserRatingsBean?> getImdbUserRatings(String uid,
    {String? href}) async {
  var response = await CacheDio().dio.get(baseUrl + '/imdb_user/$uid',
      queryParameters: {'href': href, 'action': 'ratings'});
  if (response.data['result'] == null) {
    return null;
  }
  final res = response.data['result'];
  return ImdbUserRatingsBean(
      next: res['next'],
      ratings: NewMovieListRespResult.fromJson(res['ratings']));
}
