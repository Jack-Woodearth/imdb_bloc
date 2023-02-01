import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

import '../utils/common.dart';

class MyNetworkImage extends StatelessWidget {
  const MyNetworkImage(
      {Key? key, required this.url, this.fit = BoxFit.cover, this.placeHolder})
      : super(key: key);
  final String url;
  final BoxFit fit;
  final Widget? placeHolder;
  @override
  Widget build(BuildContext context) {
    return Image(
      errorBuilder: (context, error, stackTrace) => const Center(
          child: Text('Oops. There is some error with this picture.')),
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null
              ? const Center(child: CircularProgressIndicator())
              : child,
      image: NetworkToFileImage(
          debug: false, url: url, file: File(getImageFilePath(url))),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('url', url));
  }
}
