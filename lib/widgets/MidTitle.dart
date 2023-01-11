import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MidTitle extends StatelessWidget {
  const MidTitle({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AutoSizeText(
        title,
        maxLines: 1,
        // minFontSize: 10,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
