import 'package:flutter/material.dart';

import 'package:imdb_bloc/extensions/theme_extension.dart';
import 'package:imdb_bloc/utils/colors.dart';

import '../../constants/config_constants.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: context.isDarkMode
            ? ColorsUtils.lighten(Theme.of(context).colorScheme.surface, 0.03)
            : ColorsUtils.darken(Theme.of(context).colorScheme.surface, 0.1),
        height: homeTitleHeight,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   title ?? '',
              //   style: TextStyle(color: yellowOrBlack(), fontSize: 30),
              // ),
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}
