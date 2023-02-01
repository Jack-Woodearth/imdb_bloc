import 'package:flutter/material.dart';

import 'TitleWithStartingYellowDivider.dart';
import 'see_all.dart';

class TitleAndSeeAll extends StatelessWidget {
  const TitleAndSeeAll(
      {Key? key, required this.title, this.label = '', this.onTap})
      : super(key: key);
  final String title;
  final String label;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: TitleWithStartingYellowDivider(
                  title: title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  label,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SeeAll(onTap: onTap!),
            ),
          ),
      ],
    );
  }
}
