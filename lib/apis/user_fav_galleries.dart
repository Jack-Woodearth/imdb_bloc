import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<List<String>> getUserFavGalleriesApi() async {
  var path = '$baseUrl/user_fav_galleries';
  try {
    var response = await MyDio().dio.get(path);
    var gids = response.data['result'].cast<String>();

    return gids;
  } catch (e) {
    return [];
  }
}

Future<int> addUserFavGalleriesApi(List<String> gids) async {
  var path = '$baseUrl/user_fav_galleries';
  try {
    var response = await MyDio().dio.post(path, data: gids);
    var cnt = response.data['result'] as int;
    await getUserFavGalleriesApi();
    return cnt;
  } catch (e) {
    return 0;
  }
}

Future<int> deleteUserFavGalleriesApi(List<String> gids) async {
  var path = '$baseUrl/user_fav_galleries';
  try {
    var response = await MyDio().dio.delete(path, data: gids);
    var cnt = response.data['result'] as int;
    await getUserFavGalleriesApi();
    return cnt;
  } catch (e) {
    return 0;
  }
}
