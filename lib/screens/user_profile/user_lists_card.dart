import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../apis/user_lists.dart';
import '../../utils/list_utils.dart';
import 'youscreen.dart';

class UserListsCard extends StatefulWidget {
  const UserListsCard(
      {super.key,
      required this.listUrls,
      required this.tag,
      required this.cardHeight});
  final List<String> listUrls;
  final String tag;
  final double cardHeight;
  @override
  State<UserListsCard> createState() => _UserListsCardState();
}

class _UserListsCardState extends State<UserListsCard> {
  late Future<List<String>> future;
  void initFuture() {
    future = getListsCovers(listUrls: widget.listUrls);
  }

  @override
  void initState() {
    super.initState();
    initFuture();
  }

  @override
  void didUpdateWidget(covariant UserListsCard oldWidget) {
    if (oldWidget.listUrls != widget.listUrls) {
      initFuture();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return snapshot.hasData
            ? ListsCoversStackPictures(
                pictures: firstNOfList(snapshot.data ?? [], 3),
                tag: widget.tag,
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
