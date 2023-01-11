import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';

class ImdbButton extends StatefulWidget {
  const ImdbButton(
      {Key? key, required this.onTap, required this.text, this.color})
      : super(key: key);
  final Function() onTap;
  final String text;
  final Color? color;
  @override
  State<ImdbButton> createState() => _ImdbButtonState();
}

class _ImdbButtonState extends State<ImdbButton> {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: !tapped
                ? (widget.color ?? ImdbColors.themeYellow)
                : Theme.of(context).colorScheme.surface.withOpacity(0.8),
            border: Border.all(
                width: 1, color: (widget.color ?? ImdbColors.themeYellow))),
        height: 40,
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
