import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../beans/more_from.dart';
import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';

Future<List<MoreFromResult>> getMoreFromApi(String mid) async {
  // final key = 'getMoreFromApi:$mid';
  // var preferences = Get.find<SharedPreferences>();
  // try {
  //   return MoreFromResult.fromJson(jsonDecode(preferences.getString(key)!));
  // } catch (e) {}
  var resp = await MyDio().dio.get(baseUrl + '/more_from/$mid');

  // MoreFromResult? moreFfromResult;
  List<MoreFromResult>? moreFfromResult;
  if (reqSuccess(resp)) {
    moreFfromResult = MoreFromResp.fromJson(resp.data).result;
    if (moreFfromResult != null) {
      // preferences.setString(key, jsonEncode(moreFfromResult.toJson()));
    }
    // return moreFfromResult;
  }

  return moreFfromResult ?? [];
}
