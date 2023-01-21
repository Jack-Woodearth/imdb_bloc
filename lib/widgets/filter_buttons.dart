import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/filter_button_cubit.dart';
import 'package:imdb_bloc/extensions/theme_extension.dart';
import 'package:imdb_bloc/utils/colors.dart';
import 'package:imdb_bloc/utils/dio/mydio.dart';

import '../screens/user_profile/utils/you_screen_utils.dart';
import 'FilterButton.dart';

class FilterButtons extends StatefulWidget {
  const FilterButtons({
    Key? key,
    required this.tag,
    this.btnNames = const [
      BtnNames.type,
      BtnNames.watchOptions,
      BtnNames.runtime,
      BtnNames.genres,
      BtnNames.rate,
    ],
    this.onFilterChanged,
    this.options = const {},
    this.btnNamesToExclude = const [],
  }) : super(key: key);

  final String tag;
  final List<BtnNames> btnNames;
  final List<BtnNames> btnNamesToExclude;
  final VoidCallback? onFilterChanged;
  final Map<BtnNames, List<String>> options;

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final btnNames = widget.btnNames
        .toSet()
        .difference(widget.btnNamesToExclude.toSet())
        .toList();
    return // filters
        SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        child: Row(
          children: [
            BlocBuilder<FilterButtonCubit, FilterButtonState>(
              builder: (context, state) => Row(
                children: widget.btnNames
                    .map(
                      (name) => state.filters[btnDisplayName(name)] == null
                          ? const SizedBox(
                              width: 0,
                            )
                          : Chip(
                              elevation: 5.0,
                              onDeleted: () {
                                _onRemoveFilter(context, name);
                              },
                              label: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  state.filters[btnDisplayName(name)]
                                      .toString(),
                                ),
                              )),
                    )
                    .toList(),
              ),
            ),
            Row(
              children: [
                if (btnNames.contains(BtnNames.type))
                  FilterButton(
                    scrollController: _scrollController,
                    onFilterChanged: widget.onFilterChanged,
                    tag: widget.tag,
                    name: btnDisplayName(BtnNames.type),
                    onPressed: () {},
                    options: widget.options[BtnNames.type] ??
                        const [
                          "Movie",
                          "TV Movie",
                          "TV Series",
                          "TV Episode",
                          "TV Special",
                          "Mini - Series",
                          "Documentary",
                          "Video Game",
                          "ShortFilm",
                          "Video",
                          "TV Short",
                          "Podcast Series",
                          "Podcast Episode",
                          "Music Video"
                        ],
                  ),
                if (btnNames.contains(BtnNames.runtime))
                  FilterButton(
                    scrollController: _scrollController,
                    onFilterChanged: widget.onFilterChanged,
                    tag: widget.tag,
                    name: btnDisplayName(BtnNames.runtime),
                    onPressed: () {},
                    options: widget.options[BtnNames.runtime] ??
                        const [
                          '1 hour or less',
                          '1 to 2 hours',
                          '2 to 3 hours',
                          'over 3 hours'
                        ],
                  ),
                if (btnNames.contains(BtnNames.genres))
                  FilterButton(
                    scrollController: _scrollController,
                    onFilterChanged: widget.onFilterChanged,
                    tag: widget.tag,
                    name: btnDisplayName(BtnNames.genres),
                    onPressed: () {},
                    options: widget.options[BtnNames.genres] ??
                        const [
                          'Action',
                          'Crime',
                          'Drama',
                          'Fantasy',
                          'Horror',
                          'Mystery',
                          'Sci-Fi',
                          'Thriller'
                        ],
                  ),
                if (btnNames.contains(BtnNames.rate))
                  FilterButton(
                      scrollController: _scrollController,
                      onFilterChanged: widget.onFilterChanged,
                      name: btnDisplayName(BtnNames.rate),
                      onPressed: () {},
                      options: widget.options[BtnNames.rate] ??
                          const [
                            'less than 6',
                            '6+',
                            '7+',
                            '8+',
                            '9+',
                          ],
                      tag: widget.tag),
                if (btnNames.contains(BtnNames.watchOptions))
                  FilterButton(
                    scrollController: _scrollController,
                    onFilterChanged: widget.onFilterChanged,
                    tag: widget.tag,
                    name: btnDisplayName(BtnNames.watchOptions),
                    onPressed: () {},
                    options: widget.options[BtnNames.watchOptions] ??
                        const ['Comming soon'],
                  ),
                if (btnNames.contains(BtnNames.language))
                  FilterButton(
                    scrollController: _scrollController,
                    name: 'Language',
                    onPressed: () {},
                    options: widget.options[BtnNames.language] ??
                        const [
                          'English',
                          'French',
                          'German',
                          'Spanish',
                          'Chinese',
                          'Japanese',
                          'Korean'
                        ],
                    tag: widget.tag,
                    onFilterChanged: widget.onFilterChanged,
                  ),
                // ...?btns,
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onRemoveFilter(BuildContext context, BtnNames name) {
    context.read<FilterButtonCubit>().removeK(btnDisplayName(name));
    if (widget.onFilterChanged != null) {
      widget.onFilterChanged!();
    }
  }
}
