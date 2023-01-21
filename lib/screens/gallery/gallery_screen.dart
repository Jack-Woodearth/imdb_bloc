import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_galleries_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';

import '../../apis/apis.dart';
import '../../apis/gallery.dart';
import '../../apis/get_pics_api.dart';
import '../../apis/user_fav_galleries.dart';
import '../../apis/user_fav_photos_api.dart';
import '../../beans/gallery.dart';
import '../../beans/user_fav_photos.dart';
import '../../constants/colors_constants.dart';
import '../../constants/config_constants.dart';
import '../../enums/enums.dart';
import '../../utils/common.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/PosterCardWrappedLazyLoadBean.dart';
import '../../widgets/my_network_image.dart';
import '../all_images/image_view.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key, required this.gid, required this.galleryTitle})
      : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
  final String gid;
  final String galleryTitle;
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<ImdbGallery> _galleries = [];

  int _index = 0;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant GalleryScreen oldWidget) {
    if (widget.gid != oldWidget.gid) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (_galleries.isEmpty) {
      return const SizedBox();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery images ${_pageIndex + 1}/${_galleries.length}'),
        actions: context.read<UserCubit>().state.isLogin
            ? [
                IconButton(
                  onPressed: () {
                    toggleFavPhoto(
                        PhotoWithSubjectId(
                            subjectId: '${_galleries[_pageIndex].peopleIds}'
                                .split('-')
                                .first,
                            photoUrl: _galleries[_pageIndex].image),
                        ImageViewType.other,
                        scaffoldState: ScaffoldMessenger.of(context),
                        context: context);
                  },
                  icon: BlocBuilder<UserFavPhotosCubit, UserFavPhotosState>(
                    builder: (context, state) {
                      return Icon(
                        state.photos.contains(PhotoWithSubjectId(
                                subjectId: '${_galleries[_pageIndex].peopleIds}'
                                    .split('-')
                                    .first,
                                photoUrl: _galleries[_pageIndex].image))
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: imdbYellow,
                      );
                    },
                  ),
                ),
                BlocBuilder<UserFavGalleriesCubit, List<String>>(
                  builder: (context, state) {
                    return IconButton(
                        onPressed: () async {
                          if (state.contains(widget.gid)) {
                            await deleteUserFavGalleriesApi([widget.gid]);
                          } else {
                            var i = await addUserFavGalleriesApi([widget.gid]);
                            if (i > 0) {
                              EasyLoading.showSuccess(
                                  '$i galley saved to your collection');
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                            } else {
                              EasyLoading.showError(
                                  '$i galley saved to your collection');
                            }
                          }
                        },
                        icon: Icon(
                          Icons.collections,
                          color: state.contains(widget.gid) ? imdbYellow : null,
                        ));
                  },
                )
              ]
            : [],
      ),
      body: Stack(
        // alignment: Alignment.center,
        children: [
          PageView.builder(
              itemCount: _galleries.length,
              onPageChanged: (pd) {
                // print(pd);
                if (mounted) {
                  setState(() {
                    _pageIndex = pd;
                  });
                }
              },
              itemBuilder: (context, index) {
                var g = _galleries[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Colors.black,
                          child: MyNetworkImage(
                            url: bigPic(g.image ?? defaultCover),
                            fit: BoxFit.fitHeight,
                            // placeHolder: MyNetworkImage(
                            //     url: smallPic(g.image ?? defaultCover)),
                          ),
                        )),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                );
              }),
          _galleries.isEmpty
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : Positioned(
                  top: screenHeight(context) / 2.3 + 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: [
                      SingleChildScrollView(
                        child: Container(
                          // color: Colors.red,
                          // height: 30000,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  // height: 200,
                                  width: screenWidth(context),
                                  child:
                                      Text('${_galleries[_pageIndex].title}')),
                              PeopleAndMovieOfGalleryScreen(
                                gallery: _galleries[_pageIndex],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context) / 3,
                        width: screenWidth(context),
                        child: MoviePhotosOfGalleryScreen(
                          gallery: _galleries[_pageIndex],
                        ),
                      ),
                    ][_index],
                  ),
                ),
          Positioned(
            top: screenHeight(context) / 2.3,
            height: 50,
            child: Container(
              color: Theme.of(context).cardColor,
              // color: blackOrWhite(),
              // color: Colors.red,
              width: screenWidth(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Text(
                        widget.galleryTitle,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Builder(builder: (context) {
                      // const double width = 20;
                      return Center(
                        child: ExpandIcon(
                          isExpanded: _index == 0,
                          onPressed: (v) {
                            _handleTap();
                          },
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getData() async {
    _galleries = await getGalleryApi(widget.gid);
    if (mounted) {
      setState(() {});
    }
  }

  void _handleTap() {
    if (_index == 1) {
      _index = 0;
    } else {
      _index = 1;
    }

    if (mounted) {
      setState(() {});
    }
  }
}

class MoviePhotosOfGalleryScreen extends StatefulWidget {
  const MoviePhotosOfGalleryScreen({
    Key? key,
    required this.gallery,
  }) : super(key: key);
  final ImdbGallery gallery;

  @override
  State<MoviePhotosOfGalleryScreen> createState() =>
      _MoviePhotosOfGalleryScreenState();
}

class _MoviePhotosOfGalleryScreenState
    extends State<MoviePhotosOfGalleryScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant MoviePhotosOfGalleryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gallery.id != widget.gallery.id) {
      _getData();
    }
  }

  ImdbGallery? _gallery;
  final List<PhotoWithSubjectId> _photos = [];
  bool _loading = false;
  _getData() async {
    _photos.clear();
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    // print('MoviePhotosOfGalleryScreen_getData');
    if (widget.gallery.movieIds == null) {
      ImdbGallery? imdbGallery =
          await getPeopleAndMovieOfGalleryApi(widget.gallery.id!);
      _gallery = imdbGallery;
    } else {
      _gallery = widget.gallery;
    }
    var subjectId = '';
    if (notBlank(_gallery?.movieIds)) {
      // var resp = await MyDio()
      //     .dio
      //     .get(baseUrl + '/pics/${_gallery!.movieIds!.split('-').first}');
      // if (reqSuccess(resp)) {
      //   _photos = resp.data['result'].cast<String>();
      // }
      subjectId = _gallery?.movieIds?.split('-').first ?? '';
    } else if (notBlank(_gallery?.peopleIds)) {
      subjectId = _gallery?.peopleIds?.split('-').first ?? '';
    }
    if (notBlank(subjectId)) {
      var res = await getPicsApi(subjectId);
      _photos.addAll(res);
    }

    _loading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _gallery == null || _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: _photos.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  var subjectId2 = _photos[index].subjectId ?? '';
                  pushRoute(
                      context: context,
                      screen: ImageView(
                          images: _photos,
                          initialIndex: index,
                          imageViewType: subjectId2.startsWith('nm')
                              ? ImageViewType.person
                              : subjectId2.startsWith('tt')
                                  ? ImageViewType.movie
                                  : ImageViewType.other));
                },
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: MyNetworkImage(
                      url: smallPic(_photos[index].photoUrl ?? '')),
                ),
              );
            },
          );
  }
}

class PeopleAndMovieOfGalleryScreen extends StatefulWidget {
  const PeopleAndMovieOfGalleryScreen({
    Key? key,
    required this.gallery,
  }) : super(key: key);
  final ImdbGallery gallery;

  @override
  State<PeopleAndMovieOfGalleryScreen> createState() =>
      _PeopleAndMovieOfGalleryScreenState();
}

class _PeopleAndMovieOfGalleryScreenState
    extends State<PeopleAndMovieOfGalleryScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  bool _load = false;
  @override
  void didUpdateWidget(covariant PeopleAndMovieOfGalleryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gallery.id != widget.gallery.id) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '_PeopleAndMovieOfGalleryScreenState _gallery=${_gallery?.href}');
    debugPrint('_PeopleAndMovieOfGalleryScreenState uuid=${_gallery?.id}');
    return _gallery != null && _load == false
        ? SizedBox(
            height: 230,
            width: screenWidth(context) * 0.95,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Text('${_gallery?.href}'),
                  _gallery!.peopleIds != null
                      ? Row(
                          children: _gallery!.peopleIds!
                              .split('-')
                              .map(
                                (e) => SizedBox(
                                  child: PosterCardWrappedLazyLoadBean(
                                    id: e,
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const SizedBox(),
                  _gallery!.movieIds != null
                      ? SizedBox(
                          child: PosterCardWrappedLazyLoadBean(
                            id: _gallery!.movieIds!,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )
        : SizedBox(
            width: screenWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                    child: Center(
                  child: CircularProgressIndicator(),
                )),
              ],
            ),
          );
  }

  ImdbGallery? _gallery;
  _getData() async {
    // print('PeopleAndMovieOfGalleryScreen getdata');
    _load = true;
    if (mounted) {
      setState(() {});
    }
    if (widget.gallery.peopleIds == null && widget.gallery.movieIds == null) {
      // var resp = await MyDio()
      //     .dio
      //     .get(baseUrl + '/gallery/people_and_movie?uuid=${widget.gallery.id}');
      // if (reqSuccess(resp)) {
      //   _gallery = ImdbGallery.fromJson(resp.data['result']);
      // }
      var imdbGallery = await getPeopleAndMovieOfGalleryApi(widget.gallery.id!);
      _gallery = imdbGallery;
    } else {
      _gallery = widget.gallery;
    }

    _load = false;
    if (mounted) {
      setState(() {});
    }
  }
}
