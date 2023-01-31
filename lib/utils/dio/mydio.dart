import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imdb_bloc/singletons/user.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../../constants/config_constants.dart';

class ImdbLoginInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = user.token;

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data['code'] == 25200 || response.data['code'] == 25201) {
      dp('未登录,code:${response.data['code']}url:${response.requestOptions.uri}');
      user = User();
      userStreamController.add(user);
      SharedPreferences.getInstance().then((value) => value.remove(userObjKey));
    }
    if (response.data['code'] == 505) {
      // print(response.data['msg']);
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    dp('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    networkErrorStreamController.add(
        'Oops. Something wrong with network.\nERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}

class MyDio extends BasicDio {
  MyDio() {
    dio.interceptors.add(ImdbLoginInterceptors());
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    var preferences = await SharedPreferences.getInstance();
    var key = '$path$queryParameters';

    var stringResp = await compute(preferences.getString, key);
    var string = stringResp;
    if (string != null) {
      return jsonDecode(string) as Map<String, dynamic>;
    }
    var response = await dio.get(path, queryParameters: queryParameters);
    var data = response.data as Map<String, dynamic>;
    preferences.setString(key, jsonEncode(data));
    return data;
  }
}

class ImdbWithCaptchaDio extends MyDio {
  final String captchaId;
  final String captchaCode;

  ImdbWithCaptchaDio({required this.captchaId, required this.captchaCode}) {
    dio.interceptors.add(
        CaptchaInterceptor(captchaId: captchaId, captchaCode: captchaCode));
  }
}

class CaptchaInterceptor extends Interceptor {
  final String captchaId;
  final String captchaCode;

  CaptchaInterceptor({required this.captchaId, required this.captchaCode});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['captcha_id'] = captchaId;
    options.queryParameters['captcha_code'] = captchaCode;

    return super.onRequest(options, handler);
  }
}

final dioUtil = MyDio().dio;
final options = CacheOptions(
  // A default store is required for interceptor.
  store: MemCacheStore(),

  // All subsequent fields are optional.

  // Default.
  policy: CachePolicy.forceCache,
  // Returns a cached response on error but for statuses 401 & 403.
  // Also allows to return a cached response on network errors (e.g. offline usage).
  // Defaults to [null].
  hitCacheOnErrorExcept: [401, 403, 500, 503],
  // Overrides any HTTP directive to delete entry past this duration.
  // Useful only when origin server has no cache config or custom behaviour is desired.
  // Defaults to [null].
  maxStale: const Duration(days: 1),
  // Default. Allows 3 cache sets and ease cleanup.
  priority: CachePriority.normal,
  // Default. Body and headers encryption with your own algorithm.
  cipher: null,
  // Default. Key builder to retrieve requests.
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  // Default. Allows to cache POST requests.
  // Overriding [keyBuilder] is strongly recommended when [true].
  allowPostMethod: false,
);

class CacheDio extends BasicDio {
  CacheDio() {
    // Global options
    dio.interceptors.add(DioCacheInterceptor(options: options));
  }
}

class BasicDio {
  Dio dio = Dio();
  BasicDio() {
    _fixBadCertificate(dio);
  }
  void _fixBadCertificate(Dio dio) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // print('host=$host');
        return server.contains(host);
      };
      return client;
    };
  }
}

final networkErrorStreamController = StreamController();
