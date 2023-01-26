import 'package:flutter/material.dart';
import 'package:imdb_bloc/screens/video/video.dart';

import '../../apis/apis.dart';
import '../../apis/basic_info.dart';
import '../../beans/trailers_resp.dart';

class VideoWithList extends StatefulWidget {
  const VideoWithList({Key? key, required this.mid, required this.videoId})
      : super(key: key);

  @override
  State<VideoWithList> createState() => _VideoWithListState();
  final String mid;
  final String videoId;
}

class _VideoWithListState extends State<VideoWithList> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  String title = '';
  @override
  Widget build(BuildContext context) {
    if (trailers == null) {
      return const Center(
        // child: GFLoader(type: GFLoaderType.android),
        child: CircularProgressIndicator(),
      );
    }
    return VideoScreen(
      videoId: widget.videoId,
      trailers: trailers!,
      movieTitle: title,
      mid: widget.mid,
    );
  }

  List<Trailer>? trailers;
  void _getData() async {
    trailers = await getTrailersApi(widget.mid);
    if (mounted) {
      setState(() {});
    }

    getBasicInfoApi([widget.mid]).then((value) {
      title = value.first.title ?? '';
      setState(() {});
    });
  }
}
