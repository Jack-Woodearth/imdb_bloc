import 'package:flutter/material.dart';

import '../../../apis/movie_awards_api.dart';
import '../../../constants/config_constants.dart';
import 'movie_awards.dart';

class AwardsScreen extends StatefulWidget {
  const AwardsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  int _page = 1;
  bool _end = false;
  Future<Map<dynamic, dynamic>> _getData() async {
    return (await Future.wait(
        [getMovieAwardsApi(widget.id), Future.delayed(transitionDuration)]))[0];
  }

  late Future<Map<dynamic, dynamic>> future = _getData();
  @override
  void didUpdateWidget(covariant AwardsScreen oldWidget) {
    if (oldWidget.id != widget.id) {
      future = _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == null) {
          return const SizedBox();
        }
        return AwardsDetailsWidget(
          subjectId: widget.id,
          awards: snapshot.data!,
          onScrollEnd: () async {
            if (_end) {
              return;
            }
            var map = await getMovieAwardsApi(widget.id, page: ++_page);
            snapshot.data!.addAll(map);
            _end = map.isEmpty;
          },
        );
      },
    );
  }
}
