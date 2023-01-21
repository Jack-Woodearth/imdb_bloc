import 'dart:io';

import 'package:flutter/material.dart';

class PlatformUtils {
  static bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  static double screenAspectRatio(BuildContext context) {
    return MediaQuery.of(context).size.aspectRatio;
  }

  static int gridCrossAxisCount(BuildContext context) {
    return PlatformUtils.screenAspectRatio(context) > 1 ? 4 : 2;
  }
}
