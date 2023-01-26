import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/beans/details.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import '../apis/apis.dart';
import '../beans/trailers_resp.dart';
import '../constants/config_constants.dart';
import '../screens/video/video.dart';
import '../utils/string/string_utils.dart';
import 'my_network_image.dart';
import 'youtube_image.dart';

class TrailersWidget extends StatefulWidget {
  const TrailersWidget(
      {super.key,
      required this.movieBean,
      this.trailerShowMovieDetailIcon = true});
  final MovieBean movieBean;
  final bool trailerShowMovieDetailIcon;

  @override
  State<TrailersWidget> createState() => _TrailersWidgetState();
}

class _TrailersWidgetState extends State<TrailersWidget> {
  late Future<List<Trailer>> future;
  void initFuture() {
    future = getTrailersApi(widget.movieBean.id ?? '');
  }

  @override
  void initState() {
    super.initState();
    initFuture();
    dp('_TrailersWidgetState initState ${widget.movieBean.id}');
  }

  @override
  void didUpdateWidget(covariant TrailersWidget oldWidget) {
    if (oldWidget.movieBean.id != widget.movieBean.id) {
      initFuture();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: FutureBuilder<List<Trailer>>(
          future: future,
          builder: (context, snapshot) {
            final trailers = snapshot.data ?? [];
            return trailers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : CarouselSlider.builder(
                    itemCount: trailers.length,
                    options: CarouselOptions(
                        enlargeCenterPage: true, autoPlay: false),
                    itemBuilder: (context, index, realIndex) {
                      Trailer e = trailers[index];
                      if (!(e.videoRenderer?.thumbnail?.thumbnails
                                  ?.isNotEmpty ==
                              true &&
                          !isBlank(e
                              .videoRenderer!.thumbnail!.thumbnails![0].url))) {
                        return MyNetworkImage(
                            url: bigPic(widget.movieBean.videos?.isNotEmpty ==
                                        true &&
                                    widget.movieBean.videos![0].cover != null
                                ? widget.movieBean.videos![0].cover!
                                : (widget.movieBean.photos?.isNotEmpty ==
                                            true &&
                                        !isBlank(widget
                                            .movieBean.photos![0].photoUrl)
                                    ? widget.movieBean.photos![0].photoUrl!
                                    : defaultCover)));
                      }
                      //显示封面
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox(
                                // height: 150,
                                child: YoutubeImage(
                                  fit: BoxFit.fitHeight,
                                  url: handleYoutubeImage(e.videoRenderer!
                                      .thumbnail!.thumbnails![0].url!),
                                  useProxy: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              // 播放按钮
                              child: InkWell(
                                onTap: () {
                                  //todo
                                  final movieBean = widget.movieBean;
                                  if (e.videoRenderer != null &&
                                      e.videoRenderer!.videoId != null) {
                                    pushRoute(
                                        context: context,
                                        screen: VideoScreen(
                                            showMovieDetailIcon: widget
                                                .trailerShowMovieDetailIcon,
                                            //       // from: '',
                                            movieTitle: movieBean.title ?? '',
                                            mid: movieBean.id!,
                                            trailers: snapshot.data ?? [],
                                            videoId:
                                                e.videoRenderer!.videoId!));
                                  }
                                  // if (e.videoRenderer != null &&
                                  //     e.videoRenderer!.videoId != null) {
                                  //   var videoScreen = VideoScreen(
                                  //       // from: '',
                                  //       movieTitle:
                                  //           movieBean.title ?? '',
                                  //       mid: movieBean.id!,
                                  //       trailers: _trailersCtrl.trailers,
                                  //       videoId: e.videoRenderer!.videoId!);
                                  //   if (Get.previousRoute
                                  //           .contains('$VideoWithList') ||
                                  //       Get.previousRoute
                                  //           .contains('')) {
                                  //     Get.back();
                                  //     Get.off(() => videoScreen,
                                  //         preventDuplicates: false);
                                  //   } else {
                                  //     Get.to(() {
                                  //       return videoScreen;
                                  //     }, preventDuplicates: false);
                                  //   }
                                  // } else {
                                  //   printInfo(info: '${e.videoRenderer}');
                                  //   print('no trailers');
                                  // }
                                },
                                child: const Icon(
                                  // icon: AnimatedIcons.play_pause,
                                  Icons.play_arrow_rounded,
                                  size: 50,
                                  color: Colors.white,
                                  // progress: _animationController,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
          }),
    );
  }
}
