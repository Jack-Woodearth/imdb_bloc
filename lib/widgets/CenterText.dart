import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  const CenterText({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);
  final String text;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // width: screenWidth(context) * 0.6,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
