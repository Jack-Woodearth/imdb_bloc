import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/list_utils.dart';

import '../utils/string/string_utils.dart';
import 'my_network_image.dart';

class StackedPictures extends StatelessWidget {
  const StackedPictures({
    Key? key,
    required this.pictures,
  }) : super(key: key);
  final List<String> pictures;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final sub = pictures.reversed.toList();

      double offsetFactor = 1 / sub.length;
      double picWidth =
          (constraints.maxWidth) / (1 + offsetFactor * (sub.length - 1));
      double picAspectRatio = 2 / 3;
      if (picWidth / picAspectRatio > constraints.maxHeight) {
        picWidth = constraints.maxHeight * picAspectRatio;
      }
      double offset = offsetFactor * picWidth;
      double padding =
          (constraints.maxWidth - picWidth - offset * (sub.length - 1)) / 2;
      //maxWidth=picWidth+offset * (sub.length - 1)
      // dp('offset=$offset,picWidth=$picWidth,constraints.maxWidth=${constraints.maxWidth},padding=$padding');
      if (sub.isEmpty) {
        return const SizedBox();
      }
      // if (sub.length == 1) {
      //   return AspectRatio(
      //       aspectRatio: picAspectRatio,
      //       child: MyNetworkImage(url: sub.first));
      // }
      // if (sub.length == 2) {
      //   return Stack(
      //     children: [
      //       Align(
      //         alignment: Alignment.centerRight,
      //         child: _buildPictureAndShadow(
      //             picWidth, picAspectRatio, MapEntry(0, sub[0]), sub),
      //       ),
      //       Align(
      //         alignment: Alignment.centerLeft,
      //         child: _buildPictureAndShadow(
      //             picWidth, picAspectRatio, MapEntry(1, sub[1]), sub),
      //       ),
      //     ],
      //   );
      // }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding > 0 ? padding : 0),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: sub
              .asMap()
              .entries
              .map((e) => Positioned(
                    right: e.key * offset,
                    child: _buildPictureAndShadow(
                        picWidth, picAspectRatio, e, sub),
                  ))
              .toList(),
        ),
      );
    });
  }

  // double _getOffset(int index, double width, double offset) {
  //   double center = width / 2;
  //   int centerIndex = (pictures.length ~/ 2);
  //   if (pictures.length.isEven) {
  //     if (index < centerIndex) {
  //       return center - (centerIndex - index) * offset;
  //     }else if(index==centerIndex){

  //     }
  //   } else {}
  // }

  Column _buildPictureAndShadow(double picWidth, double picAspectRatio,
      MapEntry<int, String> e, List<String> sub) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
              width: picWidth,
              // height: picWidth * picAspectRatio,
              child: AspectRatio(
                  aspectRatio: picAspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LayoutBuilder(builder: (context, constr) {
                        // dp('constr.maxWidth=${constr.maxWidth}');
                        return SizedBox(
                          height: double.infinity,
                          child: MyNetworkImage(
                            url: smallPic(e.value),
                          ),
                        );
                      }),
                      Container(
                        color: sub.indexOf(e.value) == sub.length - 1
                            ? null
                            : Colors.black26.withOpacity(
                                0.3 + 0.5 * (1 - e.key / (sub.length - 1))),
                      )
                    ],
                  ))),
        ),
      ],
    );
  }
}
