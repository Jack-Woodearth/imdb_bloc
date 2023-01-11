import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future uploadPersonImagesApi(String pid, Map<String, File> files) async {
  final url = baseUrl + '/person/$pid/upload_photos/user';
  final resp = await sendForm(url, {}, files);
  return resp.data;
}

/**
 * accepts three parameters, the endpoint, formdata (except fiels),files (key,File)
 * returns Response from server
 */
Future<Response> sendForm(
    String url, Map<String, dynamic> data, Map<String, File> files) async {
  Map<String, MultipartFile> fileMap = {};
  for (MapEntry fileEntry in files.entries) {
    File file = fileEntry.value;
    String fileName = file.path;
    fileMap[fileEntry.key] =
        MultipartFile(file.openRead(), await file.length(), filename: fileName);
  }
  data.addAll(fileMap);
  var formData = FormData.fromMap(data);

  return await MyDio().dio.post(url,
      data: formData, options: Options(contentType: 'multipart/form-data'));
}
