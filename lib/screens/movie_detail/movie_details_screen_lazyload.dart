import 'package:flutter/material.dart';

import '../../apis/apis.dart';
import '../../beans/details.dart';
import '../../constants/config_constants.dart';
import 'movie_full_detail_screen.dart';

class MovieFullDetailScreenLazyLoad extends StatefulWidget {
  const MovieFullDetailScreenLazyLoad({Key? key, required this.mid, this.cover})
      : super(key: key);
  final String mid;
  // final String? from;
  final String? cover;

  @override
  State<MovieFullDetailScreenLazyLoad> createState() =>
      _MovieFullDetailScreenLazyLoadState();
}

class _MovieFullDetailScreenLazyLoadState
    extends State<MovieFullDetailScreenLazyLoad> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  MovieBean? movieBean;
  _getData() async {
    var res = await Future.wait([
      getMovieDetailsApi([widget.mid]),
      Future.delayed(transitionDuration)
    ]);
    // await Future.delayed(transitionDuration);
    MovieDetailsResp? movieDetailsResp = res[0];
    // await Future.delayed(const Duration(milliseconds: 400));
    if (movieDetailsResp?.result?.isNotEmpty == true) {
      movieBean = movieDetailsResp?.result?.first;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: movieBean == null
          ? Stack(
              children: const [
                // Material(
                //   child: Center(
                //       child: MyNetworkImage(url: widget.cover ?? defaultCover)),
                // ),
                Material(child: Center(child: CircularProgressIndicator()))
              ],
            )
          : MovieFullDetailScreen(
              movieBean: movieBean!,
              // from: widget.from,
              // cover: widget.cover,
            ),
    );
  }
}
