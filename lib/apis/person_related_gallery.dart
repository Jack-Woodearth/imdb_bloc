import 'package:shared_preferences/shared_preferences.dart';

import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<List<String>> getPersonRelatedGalleryApi(String mid) async {
  try {
    var preferences = await SharedPreferences.getInstance();
    var key = 'getPersonRelatedGalleryApi:$mid';
    var stringList = preferences.getStringList(key);
    if (stringList != null) {
      return stringList;
    }
    var resp = await MyDio().dio.get('$baseUrl/person/$mid/related_gallery');
    var ret = resp.data['result'].cast<String>();
    preferences.setStringList(key, ret);
    return ret;
  } catch (e) {
    print('getPersonRelatedGalleryApi error: $e');
    return [];
  }
}
