import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'dart:math' as math;

class FilmographySliverStack extends StatelessWidget {
  const FilmographySliverStack({
    Key? key,
    required this.header,
    required this.children,
    this.childWidth = 125.0,
    required this.headerWidth,
  }) : super(key: key);
  final Widget header;
  final List<Widget> children;
  final double childWidth;
  final double headerWidth;
  @override
  Widget build(BuildContext context) {
    return SliverStack(children: [
      SliverPersistentHeader(
          pinned: false,
          delegate: FilmographySliverPinnedHeaderDelegate(
              min: headerWidth,
              max: childWidth * (children.length),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: header,
              ))),
      MultiSliver(
        children: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                    width: childWidth,
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Material(child: children[index])),
                childCount: children.length),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    ]);
  }
}

class FilmographySliverPinnedHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double max;
  final double min;
  FilmographySliverPinnedHeaderDelegate({
    required this.child,
    required this.max,
    required this.min,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => math.min(max, min);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
