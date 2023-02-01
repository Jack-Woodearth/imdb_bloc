import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/screens/movies_list/MoviesListScreenLazyWithIds.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';

import '../../constants/config_constants.dart';
import '../../utils/dio/dio.dart';

class LongMovieListGenreWrapper extends StatefulWidget {
  const LongMovieListGenreWrapper(
      {Key? key, required this.genre, required this.type})
      : super(key: key);
  final String genre;
  final String type;

  @override
  State<LongMovieListGenreWrapper> createState() =>
      _LongMovieListGenreWrapperState();
}

class _LongMovieListGenreWrapperState extends State<LongMovieListGenreWrapper> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(LongMovieListGenreWrapper oldWidget) {
    if (oldWidget.genre != widget.genre || widget.type != oldWidget.type) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  List<String>? ids;
  _getData() async {
    var resp = await Dio()
        .get('$baseUrl/genre/${widget.genre}?title_type=${widget.type}');
    if (reqSuccess(resp)) {
      ids = resp.data['result'].cast<String>();
      dp('genre ids.length=${ids?.length}');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ids == null
        ? Container()
        : MoviesListScreenLazyWithIds(
            movieIds: ids!, name: 'Top ${widget.genre} ${widget.type}s');
  }
}
