import 'package:flutter/material.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/utils/common.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import '../../beans/box_office_bean.dart';
import '../../constants/config_constants.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/movie_poster_card.dart';
import '../movie_detail/movie_details_screen_lazyload.dart';

class BoxOfficeListScreen extends StatefulWidget {
  const BoxOfficeListScreen({super.key, required this.boxOfficeBeans});
  final List<BoxOfficeBean> boxOfficeBeans;

  @override
  State<BoxOfficeListScreen> createState() => _BoxOfficeListScreenState();
}

class _BoxOfficeListScreenState extends State<BoxOfficeListScreen> {
  List<BoxOfficeBean> boxOfficeBeans = [];
  @override
  void initState() {
    super.initState();
    boxOfficeBeans = widget.boxOfficeBeans.toList();
  }

  @override
  void didUpdateWidget(covariant BoxOfficeListScreen oldWidget) {
    if (oldWidget.boxOfficeBeans != widget.boxOfficeBeans) {
      boxOfficeBeans = widget.boxOfficeBeans.toList();
    }
    super.didUpdateWidget(oldWidget);
  }

  var _sort = '';
  final sorts = ['Weekend gross', 'Total gross', 'Release date'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              title: const Text('Box office(US)'),
              flexibleSpace: Material(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      top: (Theme.of(context).appBarTheme.toolbarHeight ?? 40) +
                          10),
                  child: SingleChildScrollView(
                    child: Row(
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Sort by'),
                        ...sorts
                            .map((e) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _sort = e;
                                        final index = sorts.indexOf(e);
                                        if (index == 0) {
                                          boxOfficeBeans.sort(((a, b) =>
                                              -(findNumberInString(
                                                          a.weekend ?? '') ??
                                                      0.0)
                                                  .compareTo(findNumberInString(
                                                          b.weekend ?? '') ??
                                                      0.0)));
                                        } else if (index == 1) {
                                          boxOfficeBeans.sort(((a, b) =>
                                              -(findNumberInString(
                                                          a.gross ?? '') ??
                                                      0.0)
                                                  .compareTo(findNumberInString(
                                                          b.gross ?? '') ??
                                                      0.0)));
                                        } else {
                                          boxOfficeBeans.sort(((a, b) =>
                                              -(findNumberInString(
                                                          a.weeks ?? '') ??
                                                      0.0)
                                                  .compareTo(findNumberInString(
                                                          b.weeks ?? '') ??
                                                      0.0)));
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                          side: _sort == e
                                              ? BorderSide(color: imdbYellow)
                                              : null,
                                          label: Text(
                                            e,
                                            style: TextStyle(
                                                fontWeight: _sort == e
                                                    ? FontWeight.bold
                                                    : null),
                                          )),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(((context, index) {
              final boxOffice = boxOfficeBeans[index];
              return InkWell(
                onTap: () {
                  pushRoute(
                      context: context,
                      screen:
                          MovieFullDetailScreenLazyLoad(mid: boxOffice.mid!));
                },
                child: Column(
                  children: [
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: 80,
                              child: PosterWithOutTitle(
                                  posterUrl: smallPic(
                                      boxOffice.poster ?? defaultCover),
                                  id: boxOffice.mid!),
                            )),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        boxOffice.title!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                          'Weekend gross: ${boxOffice.weekend}'),
                                      Text('Total gross: ${boxOffice.gross}'),
                                      Text(
                                          'Weeks since release: ${boxOffice.weeks}'),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                ),
              );
            }), childCount: boxOfficeBeans.length))
          ],
        ),
      ),
    );
  }
}
