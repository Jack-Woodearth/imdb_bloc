import 'dart:ui';

import 'package:flutter/material.dart';

class Blurred extends StatelessWidget {
  const Blurred(
      {Key? key,
      required this.child,
      this.sigmaX = 100,
      this.sigmaY = 100,
      this.borderRadius = BorderRadius.zero})
      : super(key: key);
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
}
