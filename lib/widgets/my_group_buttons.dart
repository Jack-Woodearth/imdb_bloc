import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class MyGroupButton extends GroupButton {
  MyGroupButton({
    required super.buttons,
    super.onSelected,
    super.controller,
    super.key,
  }) : super(
          options: GroupButtonOptions(
              borderRadius: BorderRadius.circular(5.0),
              unselectedColor: Colors.grey),
          isRadio: true,
        );
}
