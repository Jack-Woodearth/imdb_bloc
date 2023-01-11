import 'dart:math';

import 'package:flutter/material.dart';

import '../../apis/basic_info.dart';
import '../../beans/poster_bean.dart';
import '../../beans/user_rated_titles.dart';
import 'youscreen.dart';

class UserRatedTitlesCard extends StatefulWidget {
  const UserRatedTitlesCard(
      {super.key,
      required this.titles,
      required this.cardHeight,
      required this.tag});
  final List<UserRatedTitle> titles;
  final double cardHeight;
  final String tag;
  @override
  State<UserRatedTitlesCard> createState() => _UserRatedTitlesCardState();
}

class _UserRatedTitlesCardState extends State<UserRatedTitlesCard> {
  late Future<List<BasicInfo>> future;
  @override
  void initState() {
    super.initState();
    initFuture();
  }

  void initFuture() {
    future = getBasicInfoApi(widget.titles
        .sublist(0, min(widget.titles.length, 3))
        .map((e) => e.mid!)
        .toList());
  }

  @override
  void didUpdateWidget(covariant UserRatedTitlesCard oldWidget) {
    if (widget.titles != oldWidget.titles) {
      initFuture();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<BasicInfo>> snapshot) {
        // print(
        //     '_UserRatedTitlesCardState pictures:${snapshot.data?.map((e) => e.image).toList() ?? []}');
        return snapshot.hasData
            ? ListsCoversStackPictures(
                pictures: snapshot.data?.map((e) => e.image).toList() ?? [],
                tag: widget.tag)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
