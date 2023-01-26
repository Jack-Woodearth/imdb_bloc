import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

import '../utils/common.dart';

class BlurredBackground extends StatelessWidget {
  const BlurredBackground(
      {Key? key,
      this.child,
      required this.backgroundImageUrl,
      this.sigmaX = 20.0,
      this.sigmaY = 20.0})
      : super(key: key);
  final Widget? child;
  final String backgroundImageUrl;
  final double sigmaX;
  final double sigmaY;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkToFileImage(
                      url: backgroundImageUrl,
                      file: File(getImageFilePath(backgroundImageUrl))))),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigmaX,
                sigmaY: sigmaY,
              ),
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  // child: child,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: child,
        ),
        // const Align(alignment: Alignment.center, child: Text('ddddddddddddddd'))
      ],
    );
  }
}
