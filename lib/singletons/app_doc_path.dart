import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppDocPath {
  static final AppDocPath _singleton = AppDocPath._internal();
  factory AppDocPath() {
    return _singleton;
  }
  AppDocPath._internal();
  late final Directory documentDirectory;

  Future<void> initialize() async {
    documentDirectory = await getApplicationDocumentsDirectory();
  }
}
