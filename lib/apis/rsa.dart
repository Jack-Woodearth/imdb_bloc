import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;

import '../constants/config_constants.dart';
import '../singletons/app_doc_path.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';

getPubKeyApi() async {
  try {
    var resp = await MyDio().dio.get('$userUrl/rsa');
    // print(resp.realUri);
    if (reqSuccess(resp)) {
      final doc = AppDocPath().documentDirectory;
      final f = File(path.join(doc.path, 'pub.pem'));
      f.writeAsBytesSync(utf8.encode(resp.data['result']));

      debugPrint(resp.data['result']);
    }
  } catch (e) {
    debugPrint('getPubKeyApi error:$e');
  }
}
