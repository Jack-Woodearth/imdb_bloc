import 'dart:io';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';
import 'package:imdb_bloc/screens/all_images/cubit/image_view_cubit.dart';
import 'package:imdb_bloc/utils/math_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

import 'package:photo_view/photo_view.dart';

import '../../apis/basic_info.dart';
import '../../apis/user_fav_photos_api.dart';
import '../../beans/poster_bean.dart';
import '../../beans/user_fav_photos.dart';
import '../../constants/config_constants.dart';
import '../../enums/enums.dart';
import '../../singletons/user.dart';
import '../../utils/common.dart';
import '../../utils/dio/mydio.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_network_image.dart';
import '../movie_detail/movie_details_screen_lazyload.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    Key? key,
    required this.images,
    this.initialIndex = 0,
    required this.imageViewType,
    this.showInfo = false,
    this.parentContext,
    this.parentKey,

    // required this.subjectId,
  }) : super(key: key);
  final List<PhotoWithSubjectId> images;
  final int initialIndex;
  final ImageViewType imageViewType;
  final bool showInfo;
  final BuildContext? parentContext;
  final GlobalKey<ScaffoldMessengerState>? parentKey;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final GlobalKey<ScaffoldMessengerState> _key =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 50)).then((value) => null); //
    });

    final controller = PageController(
      initialPage: widget.initialIndex,
    );
    return BlocProvider(
      create: (context) => ImageViewCubit()
        ..set(
            ImageViewState(curIndex: widget.initialIndex, isScrollable: true)),
      child: Scaffold(
        // backgroundColor: Colors.black,
        key: _key,
        appBar: AppBar(
          title: BlocBuilder<ImageViewCubit, ImageViewState>(
              builder: (context, state) => Text(
                  'Image ${state.curIndex + 1} / ${widget.images.length}')),
          actions: [
            BlocBuilder<UserCubit, User>(
              builder: (context, state) {
                return state.isLogin
                    ? IconButton(onPressed: () async {
                        if (widget.images.isEmpty) {
                          return;
                        }
                        var imageViewCubit = context.read<ImageViewCubit>();
                        var image = widget.images[imageViewCubit
                            .state.curIndex]; //_gtxController.cur.value//todo

                        await toggleFavPhoto(image, widget.imageViewType,
                            key: widget.parentKey,
                            scaffoldState: ScaffoldMessenger.of(context),
                            context: context);
                      }, icon:
                        BlocBuilder<UserFavPhotosCubit, UserFavPhotosState>(
                        builder: (context, state) {
                          // print(
                          //     ' BlocBuilder<UserFavPeopleCubit, UserFavPeopleState> build...');
                          return BlocBuilder<ImageViewCubit, ImageViewState>(
                              builder: (context2, state) {
                            return Icon(
                              widget.images.isNotEmpty &&
                                      isFavPhoto(widget.images[state.curIndex],
                                          context)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: ImdbColors.themeYellow,
                            );
                          });
                        },
                      ))
                    : const SizedBox();
              },
            ),
            SaveImageButton(images: widget.images),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: KeyboardListener(
            focusNode: _focusNode,
            onKeyEvent: ((event) {
              if (!_focusNode.hasFocus) {
                return;
              }
              if (event is KeyDownEvent) {
                var debugName2 = event.physicalKey.debugName;

                if (debugName2 == 'Arrow Right') {
                  if (0 + 1 < widget.images.length) {
                    //todo _gtxController.cur.value
                    controller
                        .jumpToPage(0 + 1); //todo _gtxController.cur.value
                  }
                } else if (debugName2 == 'Arrow Left') {
                  if (0 - 1 >= 0) {
                    //todo _gtxController.cur.value
                    controller
                        .jumpToPage(0 - 1); //todo _gtxController.cur.value
                  }
                }
              }
            }),
            child: BlocBuilder<ImageViewCubit, ImageViewState>(
              builder: (context, state) {
                return PageView.builder(
                  physics: state.isScrollable
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  onPageChanged: ((value) => context.read<ImageViewCubit>().set(
                      ImageViewState(
                          curIndex: value, isScrollable: state.isScrollable))),
                  controller: controller,
                  itemCount: widget.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GridTile(
                      footer: Container(
                        color: Colors.black38,
                        child: widget.images[index].imageViewerHref != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (widget.images[index]
                                                .imageViewerHref !=
                                            null) {
                                          _toggleInfoWIdget(
                                            widget
                                                .images[index].imageViewerHref!,
                                          );
                                        }
                                      },
                                      icon: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Icon(
                                          _shouldShowInfoF(widget.images[index]
                                                  .imageViewerHref!)
                                              ? Icons.close
                                              : Icons.info,
                                          color: Colors.white,
                                        ),
                                      )),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 200),
                                    // curve: Curves.easeIn,
                                    child: SizedBox(
                                      height: _shouldShowInfoF(widget
                                              .images[index].imageViewerHref!)
                                          ? null
                                          : 0,
                                      child: PicPeopleMovieInfo(
                                          href: widget
                                              .images[index].imageViewerHref!),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                      child: PhotoView(
                          scaleStateChangedCallback:
                              (PhotoViewScaleState scaleState) {
                            var read = context.read<ImageViewCubit>();
                            read.set(ImageViewState(
                                curIndex: read.state.curIndex,
                                isScrollable:
                                    scaleState == PhotoViewScaleState.initial ||
                                        scaleState ==
                                            PhotoViewScaleState.zoomedOut));
                          },
                          imageProvider: NetworkToFileImage(
                              url: bigPic(widget.images[index].photoUrl!),
                              file: File(getImageFilePath(
                                  bigPic(widget.images[index].photoUrl!)))),
                          loadingBuilder: (_, __) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  MyNetworkImage(
                                    url: smallPic(
                                        widget.images[index].photoUrl!),
                                  ),
                                  const Center(
                                    child: CircularProgressIndicator(),
                                    //  CircularProgressIndicator(),
                                  ),
                                ],
                              )),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _toggleInfoWIdget(String href) {
    // var t1 = DateTime.now();
    if (_shouldShowInfoF(href)) {
      // _showInfoHrefs.remove(href);
      // showInfoCtrl.showInfoHrefs.remove(href);//todo
    } else {
      // showInfoCtrl.showInfoHrefs.add(href);//todo
    }
    // var t2 = DateTime.now();
    // debugPrint(
    //     '_toggleInfoWIdget time: ${t2.millisecondsSinceEpoch - t1.millisecondsSinceEpoch} ms');
    // updateState(() {});
  }

  void _handleGesture(PhotoViewControllerValue controllerValue) {
    debugPrint('controllerValue.scale =${controllerValue.scale}');
    if ((controllerValue.scale ?? 0) > 1) {
      //todo
      // _gtxController.scrollable.value = false;
    } else {
      //todo
      // _gtxController.scrollable.value = true;
    }
  }

  bool _shouldShowInfoF(String href) => true;
}

class SaveImageButton extends StatelessWidget {
  const SaveImageButton({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<PhotoWithSubjectId> images;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (images.isEmpty) {
            return;
          }
          EasyLoading.show(status: 'Saving photo');
          final res = await GallerySaver.saveImage(bigPic(
              images[context.read<ImageViewCubit>().state.curIndex].photoUrl!));
          EasyLoading.showSuccess(
            res == true ? 'Image saved to gallery.' : 'Image saving failed',
          );
        },
        icon: const Icon(Icons.save));
  }
}

class ToggleInfoButton extends StatefulWidget {
  const ToggleInfoButton({
    Key? key,
    required this.onPressed,
    required this.showInitially,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool showInitially;
  @override
  State<ToggleInfoButton> createState() => _ToggleInfoButtonState();
}

class _ToggleInfoButtonState extends State<ToggleInfoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _show = widget.showInitially;
    // if (_show) {
    //   _controller.forward();
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.onPressed();
          if (!_show) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          _show = !_show;
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _controller,
          color: Theme.of(context).cardColor,
        ));
  }
}

// class ImageViewController extends GetxController {
//   var cur = 0.obs;
//   var scrollable = true.obs;
// }

class PicPeopleMovieInfo extends StatefulWidget {
  const PicPeopleMovieInfo({Key? key, required this.href}) : super(key: key);
  final String href;
  @override
  State<PicPeopleMovieInfo> createState() => _PicPeopleMovieInfoState();
}

class _PicPeopleMovieInfoState extends State<PicPeopleMovieInfo> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant PicPeopleMovieInfo oldWidget) {
    if (oldWidget.href != widget.href) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var all = pids.toList()..addAll(mids);
    if (all.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Center(child: CircularProgressIndicator()),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: all.length,
                itemBuilder: (BuildContext context, int index) {
                  return BasicInfoWidget(id: all[index]);
                },
              ),
            ),
            Text(
              title,
              style: TextStyle(color: imdbYellow, fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(subtitle),
          ],
        ),
      ),
    );
  }

  List<String> pids = [];
  List<String> mids = [];
  String title = '';
  String subtitle = '';
  void _getData() async {
    var href = widget.href;
    var response =
        await MyDio().get('$baseUrl/find_pic_person_movie_by_href?href=$href');

    var data = response['result'];
    pids = data[0].cast<String>();
    mids = data[1].cast<String>();
    title = data[2] ?? '';
    subtitle = data[3] ?? '';

    if (mounted) {
      setState(() {});
    }
  }
}

class BasicInfoWidget extends StatefulWidget {
  const BasicInfoWidget({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<BasicInfoWidget> createState() => _BasicInfoWidgetState();
}

class _BasicInfoWidgetState extends State<BasicInfoWidget> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  BasicInfo? _basicInfo;
  @override
  Widget build(BuildContext context) {
    if (_basicInfo == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return InkWell(
      onTap: () {
        if (widget.id.startsWith('tt')) {
          pushRoute(
              context: context,
              screen: MovieFullDetailScreenLazyLoad(mid: widget.id));
        } else if (widget.id.startsWith('nm')) {
          GoRouter.of(context).push('/person/${widget.id}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: SizedBox(
          width: 50,
          // height: 50,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: MyNetworkImage(url: smallPic(_basicInfo!.image))),
              ),
              AutoSizeText(
                _basicInfo!.title ?? '',
                maxLines: 2,
                minFontSize: 8,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getData() async {
    var list = await getBasicInfoApi([widget.id]);
    if (list.isNotEmpty) {
      _basicInfo = list.first;
    }
    if (mounted) {
      setState(() {});
    }
  }
}

// class InfoWidgetCtrl extends GetxController {
//   var show = false.obs;
// }

// class ShowInfoCtrl extends GetxController {
//   var showInfoHrefs = <String>{}.obs;
// }
