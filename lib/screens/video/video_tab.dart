import 'package:flutter/material.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_full_detail_screen.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import '../../apis/treading_trailers.dart';
import '../../beans/movie_trailer.dart';
import '../../widgets/TitleAndSeeAll.dart';
import '../../widgets/filter_buttons.dart';
import '../../widgets/youtube_image.dart';
import '../user_profile/utils/you_screen_utils.dart';
import 'video_with_list.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({Key? key}) : super(key: key);

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const VideoScroll(
            title: 'Trending trailers',
            trailersType: TrailersType.trending,
          );
        } else if (index == 1) {
          return const VideoScroll(
            title: 'Popular trailers',
            trailersType: TrailersType.popular,
          );
        } else if (index == 2) {
          return const VideoScroll(
            title: 'Most anticipated trailers',
            trailersType: TrailersType.anticipated,
          );
        }
        return const VideoScroll(
          title: 'Recent trailers',
          trailersType: TrailersType.recent,
        );
      },
    );
  }
}

class VideoScroll extends StatefulWidget {
  const VideoScroll({Key? key, required this.title, required this.trailersType})
      : super(key: key);
  final TrailersType trailersType;
  @override
  State<VideoScroll> createState() => _VideoScrollState();
  final String title;
}

class _VideoScrollState extends State<VideoScroll>
    with AutomaticKeepAliveClientMixin {
  // late FilterController _filterController;
  List<MovieTrailerBean> _trailers = [];
  @override
  void initState() {
    super.initState();
    // _filterController = Get.put(FilterController(), tag: widget.title);
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TitleAndSeeAll(title: widget.title, onTap: () {}),
        TitleWithStartingYellowDivider(title: widget.title),
        // FilterButtons(
        //   btnNames: const [BtnNames.type, BtnNames.genres],
        //   tag: widget.title,
        // ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _trailers.length,
            itemBuilder: (BuildContext context, int index) {
              final t = _trailers[index];

              return SizedBox(
                child:
                    //  !filtered(_filterController, t.movieBean!)
                    false
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      pushRoute(
                                          context: context,
                                          screen: VideoWithList(
                                            videoId: t.videoId,
                                            mid: t.movieBean!.id!,
                                          ));
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: YoutubeImage(
                                            url: t.trailerCover,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              t.trailerTime,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  t.movieBean!.title!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _getData() async {
    final t = widget.trailersType;

    _trailers = await getTrailersApi(t);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class ListsShowControl {
  String listUrl;
  bool show;
  ListsShowControl({required this.listUrl, this.show = true});
}
