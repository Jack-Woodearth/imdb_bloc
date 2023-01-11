import 'dart:io';

import 'package:imdb_bloc/utils/db/db.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../apis/watchlist_api.dart';
import '../../beans/recent_viewed_bean.dart';
import '../../constants/config_constants.dart';
import '../../constants/db_constants.dart';
import 'mydio.dart';

Future<String?> cacheDioGet(String url) async {
  var begin = DateTime.now().millisecondsSinceEpoch;
  final prefs = await SharedPreferences.getInstance();

  var cache = prefs.getString(url);
  var end = DateTime.now().millisecondsSinceEpoch;
  print('cacheDioGet time: ${(end - begin) / 1000}s');
  if (cache != null) {
    print('hit cache: $url');

    return cache;
  }
  var resp = await MyDio().dio.get(url);
  if (!resp.statusCode.toString().startsWith('2')) {
    return null;
  }
  var ret = resp.data as String;
  await prefs.setString(url, ret);
  return ret;
}

Future<String?> cacheDioGetDbVersion(String url) async {
  // Get a location using getDatabasesPath
  Database database = await getDb();
  if (url == 'null') {
    return null;
  }
  var dbRet =
      await database.query('web_cache', where: '"url" = ?', whereArgs: [url]);
  if (dbRet.isNotEmpty && dbRet.first['body'] != null) {
    print('hit cache: $url');
    return dbRet.first['body'] as String;
  }

  var resp = await MyDio().dio.get(url);
  if (!resp.statusCode.toString().startsWith('2')) {
    return null;
  }
  if (resp.data == null) {
    return null;
  }
  var ret = resp.data as String;
  await database.insert('web_cache', {'url': url, 'body': ret});
  return ret;
}

bool reqSuccess(Response resp) {
  return resp.statusCode != null &&
      resp.statusCode! < 400 &&
      resp.data['code'] == 200;
}
