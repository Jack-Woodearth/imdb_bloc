import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:imdb_bloc/utils/colors.dart';

import 'package:palette_generator/palette_generator.dart';

import '../../beans/hero_videos.dart';
import '../../constants/config_constants.dart';
import '../../utils/common.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_network_image.dart';

class HomeTopSliderItem extends StatelessWidget {
  const HomeTopSliderItem(
      {Key? key,
      this.img,
      this.title = '',
      this.subtitle = '',
      this.showSmallCover = true,
      this.movieCover,
      this.movieId,
      this.titleStyle,
      this.titleMaxLines,
      this.isMovie,
      this.onTitleTap})
      : super(key: key);
  final String? img;
  final String? movieId;
  final String? title;
  final String? subtitle;
  final bool showSmallCover;
  final String? movieCover;
  final TextStyle? titleStyle;
  final int? titleMaxLines;
  final bool? isMovie;
  final VoidCallback? onTitleTap;
  Future<Color> _getDominateColor() async {
    var pa = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(img ?? defaultCover));
    return pa.dominantColor!.color;
  }

  @override
  Widget build(BuildContext context) {
    // print('HomeTopSliderItem img:$img');

    return Container(
      color: ColorsUtils.secondaryBlackOrWhite(context).withOpacity(0.01),
      // height: screenWidth(context) / 1.5,
      child: Stack(
        children: [
          SizedBox(
            width: screenWidth(context),
            child: MyNetworkImage(
              url: bigPic(img ?? defaultCover),
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            bottom: 0,
            child: Container(
              // height: screenWidth(context) / 5,
              height: 50,
              width: screenWidth(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).cardColor,
                    Colors.transparent,
                  ],
                  // stops: const [
                  //   0.5,
                  //   0.9
                  // ]
                ),
              ),
            ),
          ),
          //small cover
          Positioned(
            left: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                !showSmallCover
                    ? const SizedBox()
                    : SizedBox(
                        // color: Colors.red,
                        width: 60,
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          // child: MyImage(
                          //     url: smallPic(movieCover ?? defaultCover)),
                          child: MyNetworkImage(
                              url: smallPic(movieCover ?? defaultCover)),
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth(context),
                      child: InkWell(
                        onTap: onTitleTap,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 8),
                                child: AutoSizeText(
                                  title ?? '',
                                  style: titleStyle ??
                                      Theme.of(context).textTheme.bodyLarge,
                                  maxLines: titleMaxLines ?? 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      subtitle ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
          ),
          // Positioned(
          //     bottom: 10,
          //     left: showSmallCover
          //         ? MediaQuery.of(context).size.width * (1 / 25 + 1 / 5) + 5
          //         : 15,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           title ?? '',
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         ),
          //         Text(
          //           subtitle ?? '',
          //           style: Theme.of(context).textTheme.bodySmall,
          //         )
          //       ],
          //     ))
        ],
      ),
    );
  }
}

class HomeTopSlider extends StatelessWidget {
  const HomeTopSlider({
    Key? key,
    required this.heroVideos,
  }) : super(key: key);

  final List<HeroVideos> heroVideos;

  @override
  Widget build(BuildContext context) {
    // print(heroVideos);
    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
      width: screenWidth(context),
      // height: 500,
      child: AspectRatio(
        aspectRatio:
            screenAspectRatio(context) > 1 ? screenAspectRatio(context) : 4 / 3,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (heroVideos.isNotEmpty)
              Expanded(
                  child: CarouselSlider.builder(
                      itemCount: heroVideos.length,
                      itemBuilder: (context, index, _) {
                        var e = heroVideos[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              try {
                                //todo
                                // Get.to(() => MovieListDetailScreen(
                                //     url:
                                //         '/list/${heroVideos[index].arguments?.listId}'));
                              } catch (e) {
                                // TODO
                              }
                            },
                            child: HomeTopSliderItem(
                              img: e.arguments!.slateImageOverride,
                              movieCover: e.arguments!.movieCover,
                              movieId: e.arguments!.movieId,
                              title: e.arguments!.headline,
                              subtitle: e.arguments!.subHeadline,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true, viewportFraction: 1.0))),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Browse trailers and videos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
