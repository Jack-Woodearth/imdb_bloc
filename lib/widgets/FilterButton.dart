import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/cubit/filter_button_cubit.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/widgets/filter_buttons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.name,
    required this.onPressed,
    required this.options,
    required this.tag,
    this.onFilterChanged,
    required this.scrollController,
  }) : super(key: key);
  final String name;
  final void Function() onPressed;
  final List<String> options;
  final String tag;
  final VoidCallback? onFilterChanged;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        if (Platform.isIOS || Platform.isMacOS)
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              onPressed: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (_) => CupertinoActionSheet(
                          actions: options
                              .map((option) => CupertinoActionSheetAction(
                                    onPressed: () async {
                                      _onTap(option, context);

                                      if (onFilterChanged != null) {
                                        onFilterChanged!();
                                      }
                                      GoRouter.of(context).pop();
                                    },
                                    child: Text(
                                      option,
                                    ),
                                  ))
                              .toList(),
                        ));
              },
              child: Row(
                children: [
                  Text(name),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ))
        else
          DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                // border: Border.all(width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: BlocBuilder<FilterButtonCubit, FilterButtonState>(
                builder: (context, state) {
                  return PopupMenuButton(
                      onSelected: (value) {
                        _onTap(value, context);
                      },
                      itemBuilder: ((context) => options
                          .map((option) => CheckedPopupMenuItem(
                                value: option,
                                checked: state.filters[name]?.toLowerCase() ==
                                    option.toLowerCase(),
                                child: Text(option),
                              ))
                          .toList()),
                      child: Row(
                        children: [
                          Text(name),
                          const Icon(Icons.keyboard_arrow_down_rounded)
                        ],
                      ));
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onTap(String option, BuildContext context) async {
    EasyLoading.show();
    FilterButtonCubit cubit = context.read<FilterButtonCubit>();
    cubit.setKV(name, option.toLowerCase());
    await Future.delayed(const Duration(milliseconds: 500));
    EasyLoading.dismiss();
    scrollController.jumpTo(0.0);
    // scrollController.animateTo(0.0,
    //     duration: const Duration(milliseconds: 200), curve: Curves.ease);

    dp('asdadddd ${cubit.state.filters}');
  }
}
