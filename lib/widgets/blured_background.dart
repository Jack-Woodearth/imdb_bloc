import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

import '../utils/common.dart';

class BlurredBackground extends StatelessWidget {
  const BlurredBackground(
      {Key? key, required this.child, required this.backgroundImageUrl})
      : super(key: key);
  final Widget child;
  final String backgroundImageUrl;
  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     // ConstrainedBox(
    //     //   constraints: const BoxConstraints.expand(),
    //     //   child: MyNetworkImage(url: backgroundImageUrl),
    //     // ),
    //     Positioned.fill(child: MyNetworkImage(url: backgroundImageUrl)),
    //     Center(
    //       child: ClipRRect(
    //         child: BackdropFilter(
    //           // blendMode: BlendMode.saturation,
    //           filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    //           child: Opacity(
    //             opacity: 0.2,
    //             child: Container(
    //               // width: 500.0,
    //               // height: 700.0,
    //               decoration: BoxDecoration(color: Colors.grey.shade200),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     child
    //   ],
    // );
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkToFileImage(
                        url: backgroundImageUrl,
                        file: File(getImageFilePath(backgroundImageUrl))))),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
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
        ),
        Align(
          alignment: Alignment.center,
          child: child,
        ),
        // const Align(alignment: Alignment.center, child: Text('ddddddddddddddd'))
      ],
    );
  }
}
