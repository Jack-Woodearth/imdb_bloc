import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/enums/enums.dart';
import 'package:imdb_bloc/screens/all_images/all_images.dart';
import 'package:imdb_bloc/screens/movie_detail/movie_full_detail_screen.dart';
import 'package:imdb_bloc/screens/movies_list/movies_list.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import '../../apis/apis.dart';
import '../../apis/get_pics_api.dart';
import '../../apis/user_lists.dart';
import '../../beans/details.dart';
import '../../beans/list_resp.dart';
import '../../beans/user_fav_photos.dart';
import '../../constants/config_constants.dart';
import '../../utils/common.dart';
import '../../utils/platform.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_network_image.dart';
import '../all_images/image_view.dart';
import 'home_top_slider.dart';

///首页点击Feature Today for Editors' Picsk 进入的详情页面
class MovieListDetailScreen extends StatefulWidget {
  //
  const MovieListDetailScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<MovieListDetailScreen> createState() => _MovieListDetailScreenState();
}

class _MovieListDetailScreenState extends State<MovieListDetailScreen> {
  ListResp? _listResp;

  @override
  void initState() {
    super.initState();
    init();
  }

  List<String> _mids = [];
  @override
  void didUpdateWidget(covariant MovieListDetailScreen oldWidget) {
    if (oldWidget.url != widget.url) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    _pageController.dispose();
    super.dispose();
  }

  init() async {
    debugPrint('_MovieListDetailScreenState: widget.url=${widget.url}');
    await _getData();
    _mids = _listResp?.result?.mids ?? [];
    for (var i = 0; i < (_mids.length); i++) {
      _details.add(null);
    }
    if (_mids.isNotEmpty == true) {
      _details[0] = (await getMovieDetailsApi([_mids[0]]))?.result?.first;
    }
    if (mounted) {
      setState(() {});
    }
  }

  _getData() async {
    var url = widget.url;
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    _listResp = await getListDetailApi(url);

    if (mounted) setState(() {});
  }

  // final _iconData = Icons.keyboard_arrow_down;
  bool _showWords = true;
  final PageController _pageController = PageController();
  int _curIndex = 0;
  final List<MovieBean?> _details = [];
  @override
  Widget build(BuildContext context) {
    if (_listResp?.result?.isPictureList == true) {
      return AllImagesScreen(
          data: AllImagesScreenData(
              pictures: _listResp?.result?.pictures,
              subjectId: _listResp?.result?.listUrl ?? '',
              title: _listResp?.result?.listName ?? '',
              imageViewType: ImageViewType.listPicture));
    }

    var itemCount = _mids.length;
    var details = _details;
    var description = _listResp?.result?.listDescription ?? '';
    // print('description=$description');
    var showWords = _showWords;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: _listResp == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: MovieListDetailPageView(
                onPageChanged: _onPageChanged,
                onKeyArrowPressed: _onKeyArrowPressed,
                details: details,
                pageController: _pageController,
                itemCount: itemCount,
                description: description,
                showWords: showWords,
                curIndex: _curIndex,
                mids: _listResp?.result?.mids ?? [],
              ),
            ),
    );
  }

  void _onPageChanged(int index) async {
    _curIndex = index;

    _details[_curIndex] ??=
        (await getMovieDetailsApi([_mids[_curIndex]]))?.result?.first;
    var movie = _details[_curIndex];
    if (movie == null) {
      return;
    } else if ((movie.photosCount ?? 0) > (movie.photos?.length ?? 0) + 10) {
      // EasyLoading.show(status: 'Loading more pictures...');
      // Dio().get(baseUrl + '/pics/${movie.id}').then((value) {
      //   movie.photos = (value.data)['result'].cast<String>();
      //   // EasyLoading.dismiss();
      // });

      movie.photos = await getPicsApi(movie.id);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onKeyArrowPressed() {
    setState(() {
      _showWords = !_showWords;
    });
  }
}

class MovieListDetailPageView extends StatelessWidget {
  final Function(int) onPageChanged;

  final VoidCallback onKeyArrowPressed;

  const MovieListDetailPageView({
    Key? key,
    required this.details,
    required PageController pageController,
    required this.itemCount,
    required this.description,
    required this.showWords,
    required int curIndex,
    required this.mids,
    required this.onPageChanged,
    required this.onKeyArrowPressed,
  })  : _pageController = pageController,
        _curIndex = curIndex,
        super(key: key);

  final List<MovieBean?>? details;
  final PageController _pageController;
  final int itemCount;
  final String description;
  final bool showWords;
  final int _curIndex;
  final List<String> mids;

  @override
  Widget build(BuildContext context) {
    if (details!.isNotEmpty != true) {
      return const SizedBox();
    }
    var movieBean = details?[_curIndex];
    var photos = movieBean?.photos ?? [];
    return PlatformUtils.screenAspectRatio(context) > 1
        ? AspectRatio(
            aspectRatio: 0.5,
            child: _buildMainBody(context, movieBean, photos),
          )
        : _buildMainBody(context, movieBean, photos);
  }

  Column _buildMainBody(BuildContext context, MovieBean? movieBean,
      List<PhotoWithSubjectId> photos) {
    return Column(
      children: [
        SizedBox(
          width: screenWidth(context),
          // height: 400,
          child: AspectRatio(
              aspectRatio: 3 / 2,
              child: details != null
                  ? PageView.builder(
                      controller: _pageController,
                      onPageChanged: onPageChanged,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (details?.isNotEmpty != true) {
                          return const SizedBox();
                        }
                        var movie = details![index];
                        if (movie == null) {
                          return const SizedBox();
                        }
                        String? img = getMovieBeanImage(movie);
                        return MovieListDetailPageViewPage(
                            description: description, img: img, movie: movie);
                      })
                  : const SizedBox()),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).cardColor,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: Text(
                    notBlank(description)
                        ? description
                        : 'There is no description.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              if (movieBean?.photos?.isNotEmpty == true)
                Row(
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text('${showWords ? 'Show' : 'Hide'} images')),
                    IconButton(
                        onPressed: onKeyArrowPressed,
                        icon: ExpandIcon(
                          isExpanded: !showWords,
                          onPressed: (bool value) {
                            onKeyArrowPressed();
                          },
                        )),
                  ],
                ),
            ],
          ),
        ),
        if (showWords)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${_curIndex + 1} of $itemCount'),
                  ),
                  Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Introduction',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(movieBean?.intro ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top review',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              movieBean?.topReview ?? '',
                              style:
                                  const TextStyle(fontFamily: 'TimesNewRoman'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!showWords)
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.5,
              child: (movieBean?.photos?.isNotEmpty != true)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: photos.length ~/ 3,
                      itemBuilder: (BuildContext context, int indexG) {
                        var pics = photos.sublist(
                            indexG * 3, min(photos.length, (indexG) * 3 + 3));

                        var x1 = Random().nextInt(25) + 20;
                        var x2 = Random().nextInt(25) + 20;
                        var x3 = 100 - x1 - x2;

                        var xx = [x1, x2, x3];
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: pics
                                .map(
                                  (e) => Expanded(
                                    flex: xx[pics.indexOf(e)],
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        height: 100,
                                        child: InkWell(
                                          onTap: () {
                                            pushRoute(
                                                context: context,
                                                screen: ImageView(
                                                  imageViewType:
                                                      ImageViewType.movie,
                                                  images: photos.map((e) {
                                                    return PhotoWithSubjectId(
                                                        subjectId:
                                                            movieBean?.id,
                                                        photoUrl: e.photoUrl,
                                                        imageViewerHref:
                                                            e.imageViewerHref);
                                                  }).toList(),
                                                  initialIndex:
                                                      photos.indexOf(e),
                                                ));
                                          },
                                          child: notBlank(e.photoUrl)
                                              ? MyNetworkImage(
                                                  url: smallPic(e.photoUrl!))
                                              : const SizedBox(),
                                        )),
                                  ),
                                )
                                .toList());
                      },
                    ),
            ),
          ),
      ],
    );
  }
}

class MovieListDetailPageViewPage extends StatelessWidget {
  const MovieListDetailPageViewPage({
    Key? key,
    required this.img,
    required this.movie,
    required this.description,
  }) : super(key: key);

  final String? img;
  final MovieBean movie;
  final String description;

  @override
  Widget build(BuildContext context) {
    return HomeTopSliderItem(
      showSmallCover: false,
      img: (img ?? defaultCover),
      title: movie.title,
      subtitle: description,
      titleStyle: Theme.of(context).textTheme.titleLarge,
      onTitleTap: () {
        pushRoute(
            context: context, screen: MovieFullDetailScreen(movieBean: movie));
      },
    );
  }
}

String? getMovieBeanImage(MovieBean movie) {
  String? img;
  if (movie.photos?.isNotEmpty == true) {
    img = movie.photos!.first.photoUrl;
  } else if (movie.videos?.isNotEmpty == true) {
    if (notBlank(movie.videos!.first.cover)) {
      img = movie.videos!.first.cover;
    }
  } else {
    img = movie.cover;
  }
  return img;
}
