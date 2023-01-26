import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../beans/trailers_resp.dart';
import '../../constants/colors_constants.dart';
import '../../constants/config_constants.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/youtube_image.dart';
import '../movie_detail/movie_details_screen_lazyload.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key? key,
    required this.videoId,
    this.trailers = const [],
    required this.movieTitle,
    required this.mid,
    this.showMovieDetailIcon = true,
  }) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
  final String videoId;
  final List<Trailer> trailers;
  final String movieTitle;
  final String mid;
  final bool showMovieDetailIcon;
}

class _VideoScreenState extends State<VideoScreen> {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _currentVideoId = widget.videoId;
    _initController();
  }

  void _initController() {
    _controller = YoutubePlayerController(
      initialVideoId: _currentVideoId,
      flags: const YoutubePlayerFlags(
          autoPlay: true, mute: false, useHybridComposition: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late String _currentVideoId;
  final bool _isFullScreen = false;
  @override
  Widget build(BuildContext context) {
    return _buildPlayer(context);
  }

  Scaffold _buildBody(BuildContext context, Widget player) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieTitle),
        actions: [
          if (widget.showMovieDetailIcon)
            IconButton(
                onPressed: () {
                  _controller.pause();
                  pushRoute(
                      context: context,
                      screen: MovieFullDetailScreenLazyLoad(mid: widget.mid));
                },
                icon: const Icon(Icons.movie))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            child: player,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.trailers.length,
              itemBuilder: (BuildContext context, int index) {
                var t = widget.trailers[index];

                try {
                  var url = t.videoRenderer?.thumbnail?.thumbnails?[0].url ??
                      defaultCover;
                  url = handleYoutubeImage(url);
                  return InkWell(
                    onTap: () {
                      _currentVideoId = t.videoRenderer?.videoId ?? '';
                      print('_currentVideoId=$_currentVideoId');
                      if (_currentVideoId == '') {
                        return;
                      }
                      _controller.pause();
                      _controller.load(_currentVideoId);
                      _controller.play();

                      setState(() {});
                    },
                    child: Container(
                      color: _currentVideoId == t.videoRenderer?.videoId
                          ? imdbYellow.withOpacity(0.1)
                          : null,
                      child: ListTile(
                        leading: SizedBox(
                          height: 50,
                          width: 50 * 1.5,
                          child: YoutubeImage(
                            url: url,
                            useProxy: true,
                          ),
                        ),
                        title:
                            Text(t.videoRenderer?.title?.runs?[0].text ?? ''),
                      ),
                    ),
                  );
                } catch (e) {
                  return const SizedBox(
                    height: 1,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer(BuildContext context) {
    return SafeArea(
      child: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            onEnded: (_) {},
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.white24,
            progressColors: const ProgressBarColors(
                backgroundColor: Colors.white10,
                playedColor: Colors.grey,
                handleColor: Colors.white),
          ),
          builder: (context, player) {
            return _buildBody(context, player);
          },
          onEnterFullScreen: _onEnterFullScreen,
          onExitFullScreen: _onExitFullScreen,
        ),
      ),
    );
  }

  _onExitFullScreen() async {
    // _controller.pause();
    // _isFullScreen = false;
    // final pos = _controller.value.position;
    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // await Future.delayed(const Duration(milliseconds: 1500));
    // _controller.play();

    // _controller.seekTo(pos);
  }

  void _onEnterFullScreen() async {
    // _controller.pause();
    // _isFullScreen = true;
    // final pos = _controller.value.position;

    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    // await Future.delayed(const Duration(milliseconds: 1500));
    // _controller.play();
    // _controller.seekTo(pos);
  }

  Future<bool> _onWillPop() async {
    if (_isFullScreen) {
      _onExitFullScreen();
    }
    return !_isFullScreen;
  }
}
