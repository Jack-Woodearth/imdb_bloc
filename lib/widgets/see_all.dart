import 'package:flutter/material.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          'See All',
          style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.w400,
              fontSize: 15),
        ),
      ),
    );
  }
}
