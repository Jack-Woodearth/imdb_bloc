import 'package:flutter/material.dart';

import 'MidTitle.dart';
import 'YellowDivider.dart';

class TitleWithStartingYellowDivider extends StatelessWidget {
  const TitleWithStartingYellowDivider({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const YellowDivider(),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: MidTitle(title: title)),
        ],
      ),
    );
  }
}
