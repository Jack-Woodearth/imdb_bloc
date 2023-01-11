import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../beans/person_awards_list_resp.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<List<String>> getPersonWorkedWithIds(String pid) async {
  try {
    var sharedPreferences = await SharedPreferences.getInstance();
    final key = 'getPersonWorkedWithIds:$pid';
    // try {
    //   // var string = sharedPreferences.getString(key);
    //   var stringRes = await CommonWorkerIsolate()
    //       .requestTask(sharedPreferences.getString, key);
    //   var string = stringRes.result;
    //   if (string != null && string.isNotEmpty) {
    //     var jsonResponse =
    //         await CommonWorkerIsolate().requestTask(jsonDecode, string);
    //     // return jsonDecode(string).cast<String>();
    //     return jsonResponse.result.cast<String>();
    //   }
    // } catch (e) {
    //   print('getPersonWorkedWithIds error: $e');
    // }
    var resp = await MyDio().dio.get('$baseUrl/worked_with/$pid');
    var ids = resp.data['result'].cast<String>();
    // sharedPreferences.setString(key, jsonEncode(ids));
    return ids;
  } catch (e) {
    print('getPersonWorkedWithIds error:$e');
    return [];
  }
}

Future<List<String>> getCommonMidsApi(String pid1, String pid2) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var key = 'getCommonMidsApi:$pid1,$pid2';
  var string = sharedPreferences.getString(key);
  if (string == null) {
    key = 'getCommonMidsApi:$pid2,$pid1';
    string = sharedPreferences.getString(key);
  }
  try {
    return jsonDecode(string!);
  } catch (e) {}
  try {
    var resp = await MyDio()
        .dio
        .get('$baseUrl/worked_in_movies?pid1=$pid1&pid2=$pid2');
    List<String> mids = resp.data['result'].cast<String>();
    sharedPreferences.setString(key, jsonEncode(mids));
    return mids;
  } catch (e) {
    return [];
  }
}

Future<List<AwardBean>> getAwardsApi(String pid) async {
  var awardsResp = await MyDio().get('$baseUrl/awards/$pid');
  var awards = PersonAwardsResp.fromJson(awardsResp).result ?? [];
  return awards;
}

Future getPersonFullBio(String pid) async {
  var resp = await MyDio().dio.get('$baseUrl/person/$pid/full_bio');
  return resp.data['result'] ?? [];
}
