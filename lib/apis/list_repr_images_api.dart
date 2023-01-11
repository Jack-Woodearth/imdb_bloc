import 'package:dio/dio.dart';

import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';

Future<List<String>> getListReprImagesApi(String listUrl) async {
  var response = await Dio().get('$baseUrl/list/repr_images?list_url=$listUrl');
  if (reqSuccess(response)) {
    var cast = response.data['result'].cast<String>();
    if (cast.length > 0) {
      return cast;
    }
  }
  return [defaultCover];
}
