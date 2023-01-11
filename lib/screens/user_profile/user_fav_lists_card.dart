import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../apis/fav_lists.dart';
import 'youscreen.dart';

class UserFavListCard extends StatefulWidget {
  const UserFavListCard(
      {super.key, required this.tag, required this.cardHeight});
  final String tag;
  final double cardHeight;
  @override
  State<UserFavListCard> createState() => _UserFavListCardState();
}

class _UserFavListCardState extends State<UserFavListCard> {
  late final Future<List<String>> future;
  @override
  void initState() {
    super.initState();
    future = getFavListsCovers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return snapshot.hasData
            ? ListsCoversStackPictures(
                pictures: snapshot.data ?? [],
                tag: widget.tag,
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class UserFavListsCountWidget extends StatefulWidget {
  const UserFavListsCountWidget({super.key});

  @override
  State<UserFavListsCountWidget> createState() =>
      _UserFavListsCountWidgetState();
}

class _UserFavListsCountWidgetState extends State<UserFavListsCountWidget> {
  late final Future<int?> future;
  @override
  void initState() {
    super.initState();
    future = getFavListCountApi();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text('${snapshot.data ?? 0} favorite lists');
      },
    );
  }
}
