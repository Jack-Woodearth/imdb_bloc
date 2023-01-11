import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedTextField extends StatefulWidget {
  const AnimatedTextField(
      {Key? key,
      required this.hint,
      required this.onChange,
      this.fontSize = 15})
      : super(key: key);
  final String hint;
  final Function(String) onChange;
  final double fontSize;
  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  double _scale = 1.0;
  final FocusNode _focusNode = FocusNode();

  final _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  Alignment _align = Alignment.centerLeft;
  double? _inputHeight;
  Color? _hintColor;

  final _duration = const Duration(milliseconds: 200);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        child: Container(
          color: Theme.of(context).cardColor,
          // height: 80,
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            alignment: _align,
            children: [
              GestureDetector(
                onTap: () {
                  _focusNode.requestFocus();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: AnimatedAlign(
                    alignment: _align,
                    duration: _duration,
                    child: AnimatedScale(
                      alignment: Alignment.topLeft,
                      scale: _scale,
                      duration: _duration,
                      child: Text(
                        widget.hint,
                        style: TextStyle(fontSize: 20, color: _hintColor),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // height: _inputHeight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 10.0,
                  ),
                  child: CupertinoTextField(
                    // decoration: const InputDecoration(
                    //     contentPadding: EdgeInsets.only(left: 8.0, top: 15.0)),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    controller: _textController,
                    focusNode: _focusNode,
                    style: TextStyle(
                        fontSize: widget.fontSize,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    onChanged: (value) {
                      widget.onChange(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFocusChange() async {
    if (_focusNode.hasFocus) {
      setState(() {
        _scale = 0.6;
        _hintColor = null;
        _align = Alignment.topLeft;
      });

      // await Future.delayed(
      //     Duration(milliseconds: _duration.inMilliseconds ~/ 2));
      // setState(() {
      //   _inputHeight = null;
      // });
    } else if (_textController.text.isEmpty) {
      setState(() {
        _scale = 1.0;
        _hintColor = Colors.grey;
        _align = Alignment.centerLeft;
      });
      // await Future.delayed(
      //     Duration(milliseconds: _duration.inMilliseconds ~/ 2));
      // setState(() {
      //   _inputHeight = 0.0;
      // });
    }
  }
}
