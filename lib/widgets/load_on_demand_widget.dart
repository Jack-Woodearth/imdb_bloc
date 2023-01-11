import 'package:flutter/material.dart';

class LoadOnDemandWidget extends StatefulWidget {
  const LoadOnDemandWidget(
      {Key? key, required this.child, this.load = false, required this.isInit})
      : super(key: key);
  final bool load;
  final bool isInit;
  final Widget child;
  @override
  State<LoadOnDemandWidget> createState() => _LoadOnDemandWidgetState();
}

class _LoadOnDemandWidgetState extends State<LoadOnDemandWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.load || !widget.isInit ? widget.child : const SizedBox();
  }
}
