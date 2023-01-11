import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../utils/string/string_utils.dart';
import 'my_network_image.dart';

class ThreePicturesAndTextWidget extends StatelessWidget {
  const ThreePicturesAndTextWidget(
      {Key? key, this.onTap, required this.text, required this.pictures})
      : super(key: key);
  final VoidCallback? onTap;
  final String text;
  final List<String> pictures;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SizedBox(
        height: 210.0,
        child: Card(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pictures
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: SizedBox(
                                  // width: screenWidth(context) / 4,
                                  child: AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: MyNetworkImage(url: smallPic(e)),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    text,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
