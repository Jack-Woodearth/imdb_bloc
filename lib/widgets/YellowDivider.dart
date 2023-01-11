import 'package:flutter/material.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 20,
      decoration: BoxDecoration(
          color: ImdbColors.themeYellow,
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
