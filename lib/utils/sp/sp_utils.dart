import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/config_constants.dart';

class SpCache {
  DateTime created;
  Duration timeout;
  Map<String, dynamic> data;
  Duration get ttl => Duration(
      milliseconds: timeout.inMilliseconds -
          (DateTime.now().millisecondsSinceEpoch -
              created.millisecondsSinceEpoch));
  SpCache({required this.data, required this.timeout, required this.created});

  factory SpCache.fromJson(Map<String, dynamic> json) {
    dp('SpCache.fromJson9998998989');
    return SpCache(
        created: DateTime.parse(json['created']),
        timeout: Duration(milliseconds: json['timeout']),
        data: json['data']);
  }

  Map<String, dynamic> toJson() => {
        'created': created.toIso8601String(),
        'timeout': timeout.inMilliseconds,
        'data': data,
      };
  bool get expired =>
      DateTime.now().millisecondsSinceEpoch - created.millisecondsSinceEpoch >
      timeout.inMilliseconds;
  static Future<T?> get<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    var sp = await SharedPreferences.getInstance();

    var string = sp.getString(key);
    if (string == null) {
      return null;
    }
    var jsonDecode2 = await compute(jsonDecode, string);
    var spCache = SpCache.fromJson(jsonDecode2);

    if (spCache.expired) {
      sp.remove(key);
      return null;
    }
    if (isDebug) {
      dp('SpCache.get,key=$key,ttl=${spCache.ttl}');
    }
    // return await compute(fromJson, spCache.data);
    return fromJson(spCache.data);
  }

  static void set(String key, dynamic data,
      {Duration timeout = const Duration(days: 1)}) async {
    var json =
        SpCache(data: data.toJson(), timeout: timeout, created: DateTime.now())
            .toJson();
    var sp = await SharedPreferences.getInstance();
    // print(json);
    sp.setString(key, jsonEncode(json));
    // print(sp.getString(key));
  }

  /// function: a function that has onlt positional params
  /// params: the function's params as a List
  static Future<T> wrapped<T>(
      T Function(Map<String, dynamic>) fromJson, Function function, List params,
      {Duration timeout = const Duration(days: 1)}) async {
    String key = '$function(${params.join(',')})';

    var cache = await get(key, fromJson);
    if (cache != null) {
      return cache;
    }
    dp('$function begins');
    dp('$function params=$params');
    var ret;
    if (params.isEmpty) {
      ret = await function();
    } else if (params.length == 1) {
      ret = await function(params[0]);
    } else if (params.length == 2) {
      ret = await function(params[0], params[1]);
    } else if (params.length == 3) {
      ret = await function(params[0], params[1], params[2]);
    } else if (params.length == 4) {
      ret = await function(params[0], params[1], params[2], params[3]);
    }
    if (ret != null) {
      set(key, ret, timeout: timeout);
    }
    dp('$function ends');
    return ret;
  }
}

///T should only be simple types like int,String...
class SpListCache<T> {
  DateTime created;
  Duration timeout;
  List<T> data;
  Duration get ttl => Duration(
      milliseconds: timeout.inMilliseconds -
          (DateTime.now().millisecondsSinceEpoch -
              created.millisecondsSinceEpoch));

  SpListCache(
      {required this.data, required this.timeout, required this.created});

  factory SpListCache.fromJson(Map<String, dynamic> json) => SpListCache(
      created: DateTime.parse(json['created']),
      timeout: Duration(milliseconds: json['timeout']),
      data: json['data'].cast<T>());

  Map<String, dynamic> toJson() => {
        'created': created.toIso8601String(),
        'timeout': timeout.inMilliseconds,
        'data': data,
      };
  bool get expired =>
      DateTime.now().millisecondsSinceEpoch - created.millisecondsSinceEpoch >
      timeout.inMilliseconds;

  static Future<List<T>?> get<T>(String key) async {
    var sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (string == null) {
      return null;
    }
    var spCache = SpListCache.fromJson(jsonDecode(string));
    if (spCache.expired) {
      sp.remove(key);
      return null;
    }
    if (isDebug) {
      print('SpListCache.get,key=$key,ttl=${spCache.ttl}');
    }

    return spCache.data.cast<T>();
  }

  static void set(String key, List data,
      {Duration timeout = const Duration(days: 1)}) async {
    var json =
        SpListCache(data: data, timeout: timeout, created: DateTime.now())
            .toJson();
    var sp = await SharedPreferences.getInstance();
    sp.setString(key, jsonEncode(json));
  }

  static Future<List<T>> wrapped<T>(function, List params,
      {Duration timeout = const Duration(days: 1)}) async {
    var key = '$function(${params.join(',')})';
    var cache = await get<T>(key);
    if (cache != null) {
      return cache;
    }
    var ret;
    print('$function begins');
    print('$function params=$params');
    if (params.isEmpty) {
      ret = await function();
    } else if (params.length == 1) {
      ret = await function(params[0]);
    } else if (params.length == 2) {
      ret = await function(params[0], params[1]);
    } else if (params.length == 3) {
      ret = await function(params[0], params[1], params[2]);
    } else if (params.length == 4) {
      ret = await function(params[0], params[1], params[2], params[3]);
    }
    if (ret != null) {
      set(key, ret);
    }
    print('$function ends');

    return ret;
  }
}
