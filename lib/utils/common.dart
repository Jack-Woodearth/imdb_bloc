import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../singletons/app_doc_path.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String getImageFilePath(String imageUrl) {
  // Directory documentDirectory = await getApplicationDocumentsDirectory();
  Directory documentDirectory = AppDocPath().documentDirectory;
  var filepath = p.join(documentDirectory.path, getFilename(imageUrl));
  return filepath;
}

String getFilename(String imgUrl) {
  return imgUrl
      .split('/images/')
      .last
      .replaceAll('/', '-')
      .replaceAll(':', '-');
}

double screenAspectRatio(BuildContext context) {
  return screenWidth(context) / screenHeight(context);
}
