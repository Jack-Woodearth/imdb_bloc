import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_rated_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';

import '../apis/apis.dart';
import '../apis/watchlist_api.dart';
import '../beans/details.dart';
import '../utils/dio/dio.dart';
import '../utils/string/string_utils.dart';
import '../widget_methods/widget_methods.dart';
import 'WatchListIcon.dart';
import 'my_network_image.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    Key? key,
    required this.posterUrl,
    this.rank,
    this.rate,
    this.age,
    this.additionalWidget,
    this.movieBean,
    required this.title,
    required this.id,
    this.onTap,
    this.tinyImage = false,
    this.showAge = false,
    this.yearRange,
    this.hideRate = false,
  }) : super(key: key);
  final String posterUrl;
  final int? rank;
  final double? rate;
  final String title;
  final int? age;
  final String id;
  final Widget? additionalWidget;
  final MovieBean? movieBean;
  final void Function()? onTap;
  final bool tinyImage;
  final bool showAge;
  final String? yearRange;
  final bool hideRate;
  @override
  Widget build(BuildContext context) {
    // assert();

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        if (id.startsWith('tt') && movieBean != null) {
          GoRouter.of(context).push('/title/$id');
          // Get.to(
          //     () => TransitionAwaited(
          //           child: MovieFullDetailScreen(
          //             movieBean: movieBean!,
          //           ),
          //           placeHolder: MyNetworkImage(url: movieBean!.cover),
          //         ),
          //     preventDuplicates: false,
          //     routeName: '$MovieFullDetailScreen');
        } else if (id.startsWith('tt') && movieBean == null) {
          GoRouter.of(context).push('/title/$id');
          // Get.to(
          //     () => MovieFullDetailScreenLazyLoad(
          //           mid: id,
          //           cover: posterUrl,
          //         ),
          //     preventDuplicates: false);
        } else if (id.startsWith('nm')) {
          GoRouter.of(context).push('/person/$id');
          // Get.to(() => PersonDetailScreen(pid: id), preventDuplicates: false);
        }
      },
      child: Card(
        // color: Theme.of(context).colorScheme.surface,
        // color: Colors.black,
        clipBehavior: Clip.hardEdge,
        child: AspectRatio(
          aspectRatio: 1 / 2.5,
          child: SizedBox(
            // padding: const EdgeInsets.only(right: 10),
            // width: double.infinity,
            // height: 300,
            child: Column(

                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosterWithOutTitle(
                      isTinyImage: tinyImage, posterUrl: posterUrl, id: id),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (rank != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '$rank',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[600]),
                              ),
                            ),
                          if (rate != null && !hideRate)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('$rate',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[400])),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: AutoSizeText(
                              title,
                              maxLines: 1,
                              minFontSize: 10,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          if (showAge && id.startsWith('nm'))
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: age != 0 && age != null
                                  ? Text('$age')
                                  :
                                  // const Text('no age')
                                  FutureBuilder(
                                      future: getPersonAgeApi(id),
                                      initialData: 0,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.data != null) {
                                          return Text('${snapshot.data}');
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                            ),
                          if (yearRange != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: AutoSizeText(
                                yearRange!,
                                maxLines: 1,
                                minFontSize: 10,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (additionalWidget != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: additionalWidget,
                    )
                ]),
          ),
        ),
      ),
    );
  }
}

class PosterWithOutTitle extends StatelessWidget {
  const PosterWithOutTitle({
    Key? key,
    required this.posterUrl,
    required this.id,
    this.isTinyImage = false,
  }) : super(key: key);

  final String posterUrl;
  final String id;
  final bool isTinyImage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: 2 / 3,
          child: SizedBox(
            // child: Text('poster'),
            child: MyNetworkImage(
              url: isTinyImage ? tinyPic(posterUrl) : smallPic(posterUrl),
            ),
          ),
        ),
        if (id.startsWith('tt'))
          Positioned(
            top: 0,
            left: 0,
            child: WatchListIcon(id: id),
            // child: SizedBox(),
          ),
        if (id.startsWith('tt'))
          BlocBuilder<UserRatedCubit, UserRatedState>(
            builder: (_, state) {
              var rate2 = getRate(id, context);
              if (rate2 == null) {
                return const SizedBox();
              }
              return Positioned.fill(
                // bottom: 0,
                child: (isRated(id, context))
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            // width: 500,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    '${rate2.createTime?.substring(0, 10)}',
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.green,
                                ),
                                // if ((rate2.rate ?? 10) < 10) const Text(' '),
                                if (rate2.rate != null) Text('${rate2.rate} '),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              );
            },
          ),
        if (id.startsWith('nm'))
          Positioned(
            left: 5,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                handleUpdateWatchListOrFavPeople(id, context);
              },
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.5),
                    border: Border.all(width: 0.9, color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Builder(
                        builder: (_) =>
                            BlocBuilder<UserFavPeopleCubit, UserFavPeopleState>(
                              builder: (context, state) {
                                return Icon(
                                  state.ids.contains(id)
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: state.ids.contains(id)
                                      ? ImdbColors.themeYellow
                                      : Colors.white,
                                );
                              },
                            )),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('posterUrl', posterUrl));
  }
}

class WatchListIcon extends StatelessWidget {
  const WatchListIcon({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await handleUpdateWatchListOrFavPeople(id, context);
      },
      child: SizedBox(
        width: 30,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Builder(
            builder: (_) => BlocBuilder<UserWatchListCubit, UserWatchListState>(
              builder: (context, state) {
                return CustomPaint(
                  painter: BookMarkPainter(
                    strokeColor: state.ids.contains(id)
                        ? ImdbColors.themeYellow
                        : Colors.black87.withOpacity(0.5),
                    strokeWidth: 10,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  child: Center(
                    child: BlocBuilder<UserWatchListCubit, UserWatchListState>(
                      builder: (context, state) {
                        return Icon(
                          state.ids.contains(id) ? Icons.check : Icons.add,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
