import 'package:dio/dio.dart';
import 'dart:convert';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<Response> getHttpThruProxy(String url,
    {String contentType = 'html'}) async {
  var resp = await MyDio().dio.get('$baseUrl/proxy', queryParameters: {
    'url': base64.encode(utf8.encode(url)),
    'content_type': contentType
  });

  return resp;
}
