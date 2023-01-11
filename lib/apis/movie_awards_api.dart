import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<Map> getMovieAwardsApi(String mid, {int page = 1}) async {
  var response = await MyDio()
      .dio
      .get('$baseUrl/movie/awards/$mid', queryParameters: {'page': page});
  // return MovieAwardsResp.fromJson(response.data).result ?? [];
  return response.data['result'] ?? {};
}

Future<int?> getMovieAwardsCountApi(String mid, {int page = 1}) async {
  var response = await MyDio()
      .dio
      .get('$baseUrl/movie/awards/$mid', queryParameters: {'action': 'count'});
  // return MovieAwardsResp.fromJson(response.data).result ?? [];
  return response.data['result'];
}
