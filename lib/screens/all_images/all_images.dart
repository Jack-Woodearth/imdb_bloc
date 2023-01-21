import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';
import 'package:imdb_bloc/screens/all_images/cubit/images_selection_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:synchronized/synchronized.dart';

import '../../apis/get_pics_api.dart';
import '../../apis/upload_images_api.dart';
import '../../apis/user_fav_photos_api.dart';
import '../../beans/list_resp.dart';
import '../../beans/user_fav_photos.dart';
import '../../constants/config_constants.dart';
import '../../enums/enums.dart';
import '../../utils/common.dart';
import '../../utils/platform.dart';
import '../../utils/string/string_utils.dart';
import '../../widget_methods/widget_methods.dart';
import '../../widgets/my_network_image.dart';
import 'image_view.dart';

class AllImagesScreenData {
  final String subjectId;
  final String title;
  final List<ListPicture>? pictures;
  final VoidCallback? onScrollEnd;
  final bool showInfo;
  final ImageViewType imageViewType;
  const AllImagesScreenData({
    required this.subjectId,
    required this.title,
    this.pictures,
    this.onScrollEnd,
    this.showInfo = false,
    required this.imageViewType,
  });
}

class AllImagesScreen extends StatefulWidget {
  const AllImagesScreen({
    Key? key,
    required this.data,
    // required this.subjectId,
    // required this.title,
    // this.pictures,
    // this.onScrollEnd,
    // this.showInfo = false,
    // required this.imageViewType,
  }) : super(key: key);
  // final String subjectId;
  // final String title;
  // final List<ListPicture>? pictures;
  // final VoidCallback? onScrollEnd;
  // final bool showInfo;
  // final ImageViewType imageViewType;
  final AllImagesScreenData data;
  @override
  State<AllImagesScreen> createState() => _AllImagesScreenState();
}

class _AllImagesScreenState extends State<AllImagesScreen> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(_listenScrollVelocity);
    _getData();
  }

  @override
  void didUpdateWidget(AllImagesScreen oldWidget) {
    if (oldWidget.data.subjectId != widget.data.subjectId) {
      debugPrint('didUpdateWidget2222');
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  final List<PhotoWithSubjectId> _all = [];

  bool _loading = true;
  int _page = 1;
  // int _count = 0;
  bool _allPicsHasBeenLoaded = false;

  Future<void> _getData() async {
    if (_imageViewType == ImageViewType.userFavorite) {
      await updateUserFavPhotos(context);
      _loading = false;
      setState(() {});
      return;
    }
    if (_allPicsHasBeenLoaded) {
      _loading = false;
      setState(() {});
      return;
    }
    // EasyLoading.show();

    _all.clear();
    _page = 1;
    _loading = true;
    if (mounted) {
      setState(() {});
    }
    if (_imageViewType == ImageViewType.listPicture) {
      for (var p in widget.data.pictures ?? <ListPicture>[]) {
        _all.add(PhotoWithSubjectId(
            photoUrl: p.pic,
            subjectId: widget.data.subjectId,
            imageViewerHref: p.mediaViewerHref));
        // print(p);
      }
    } else {
      await _getSubjectPics();
    }
    _loading = false;
    if (mounted) {
      setState(() {});
    }
    // EasyLoading.dismiss();
  }

  Future<void> _getSubjectPics() async {
    debugPrint('_getSubjectPics');
    debugPrint('begin: _all = ${_all.length}');

    if (_allPicsHasBeenLoaded) {
      return;
    }
    _loading = true;
    // Get.find<ImagesLoadingController>().loading.value = true;
    List<PhotoWithSubjectId> res = (await Future.wait([
      getPicsApi(widget.data.subjectId, page: _page++),
      Future.delayed(transitionDuration)
    ]))[0];
    if (res.isEmpty) {
      _allPicsHasBeenLoaded = true;
    } else {
      _all.addAll(res);
      _allPicsHasBeenLoaded = false;
    }
    _loading = false;
    // Get.find<ImagesLoadingController>().loading.value = false;
    debugPrint('end: _all = ${_all.length}');
  }

  final _controller = ScrollController();
  final _key = GlobalKey<ScaffoldMessengerState>();
  final RefreshController _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImagesSelectionCubit(),
      child: Builder(builder: (context) {
        return ScaffoldMessenger(
          key: _key,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: _buildFLoatingActionButton(),
            appBar: _buildAppBar(context),
            body: SmartRefresher(
                controller: _refreshController,
                header: const WaterDropHeader(),
                enablePullUp: allowPullUp,
                onRefresh: _onRefresh,
                onLoading: () async {
                  await _onLoading();
                  _refreshController.loadComplete();
                },
                child: _buildBody()),
          ),
        );
      }),
    );
  }

  Future<void> _onRefresh() async {
    await _getData();
    _refreshController.refreshCompleted();
  }

  bool allowPullUp = true;
  Future _onLoading() async {
    if (_loading) {
      return;
    }
    var list = _imageViewType == ImageViewType.userFavorite
        ? context.read<UserFavPhotosCubit>().state.photos
        : _all;
    var count = list.length;
    _loading = true;
    debugPrint('_buildGridView ScrollEndNotification');
    if (widget.data.onScrollEnd != null) {
      widget.data.onScrollEnd!();
      if (_imageViewType == ImageViewType.listPicture) {
        await _getData();
      }
    }
    if (!_allPicsHasBeenLoaded &&
        [ImageViewType.movie, ImageViewType.person].contains(_imageViewType)) {
      await _getSubjectPics();
    }
    _loading = false;
    var newCount = list.length;
    allowPullUp = newCount != count;
    if (mounted) {
      setState(() {});
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.data.title,
        maxLines: 1,
      ),
      bottom: PreferredSize(
        preferredSize: Size(screenWidth(context), 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      '${widget.data.title} ',
                      maxLines: 1,
                    ),
                    if (_imageViewType == ImageViewType.userFavorite)
                      BlocBuilder<UserFavPhotosCubit, UserFavPhotosState>(
                        builder: (context, state) {
                          return Text('${state.photos.length} in total');
                        },
                      )
                    else if (_imageViewType == ImageViewType.listPicture)
                      Text('${widget.data.pictures?.length} in total')
                    else
                      SubjectPhotosCountWidget(
                          subjectId: widget.data.subjectId,
                          allLength: _all.length),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        BlocBuilder<ImagesSelectionCubit, ImagesSelectionState>(
          builder: (context, state) {
            return IconButton(
                onPressed: () {
                  _handleFavPhotos(context);
                },
                icon: state.selected.isEmpty
                    ? const SizedBox()
                    : Icon(
                        _imageViewType == ImageViewType.userFavorite
                            ? Icons.favorite_outline
                            : Icons.favorite,
                        color: ImdbColors.themeYellow,
                      ));
          },
        ),
        IconButton(
            onPressed: () {
              _toggleSelectAll(context);
            },
            icon: const Icon(Icons.select_all)),
        _imageViewType == ImageViewType.userFavorite
            ? const SizedBox()
            : IconButton(
                onPressed: _handleAddImages, icon: const Icon(Icons.add))
      ],
    );
  }

  Widget _buildFLoatingActionButton() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: '' == '' //todo
          ? 0.0
          : 0.8,
      child: Card(
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _controller.animateTo(0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInCirc);
                },
                child: const Icon(Icons.keyboard_arrow_up, size: 45),
              ),
              InkWell(
                onTap: () {
                  _controller.animateTo(_controller.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInCirc);
                },
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // printInfo(info: '_buildBody');
    debugPrint('_imageViewType=$_imageViewType');
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_imageViewType == ImageViewType.userFavorite) {
      return BlocBuilder<UserFavPhotosCubit, UserFavPhotosState>(
        builder: (context, state) {
          return _buildGridView(state.photos);
        },
      );
    }

    return _buildGridView(_all);
  }

  Widget _buildGridView(List<PhotoWithSubjectId> images) {
    return GridView.builder(
      clipBehavior: Clip.hardEdge,
      controller: _controller,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () {
            var imagesSelectionCubit = context.read<ImagesSelectionCubit>();
            imagesSelectionCubit.addAll([images[index]]);
            imagesSelectionCubit.enableSelection();
          },
          onTap: () {
            _handleTap(images, index, context);
          },
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyNetworkImage(
                    fit: BoxFit.cover, url: smallPic(images[index].photoUrl!)),
                BlocBuilder<ImagesSelectionCubit, ImagesSelectionState>(
                  builder: (context, state) {
                    return Container(
                      color: state.selected.contains(images[index])
                          ? ImdbColors.themeYellow.withOpacity(0.5)
                          : Colors.transparent,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: PlatformUtils.screenAspectRatio(context) > 1 ? 6 : 3,
      ),
    );
  }

  void _handleTap(
      List<PhotoWithSubjectId> images, int index, BuildContext context) {
    print('tap $index');
    // 服务器返回的图片列表必须没有重复图片，否则bug： 全选后，点击某个图片，本应取消选中，但是由于该图片有相同图片，
    //==判断相等，contains（）返回true，这时点击取消选中的可能不是该图片而是它的分身。由于两张图图片可能相距很远，在同一屏
    //上看不到，造成全选后，需要点击两次（或以上）才能取消选中该图片的假象
    var image = images[index];
    var imagesSelectionCubit = context.read<ImagesSelectionCubit>();
    if (imagesSelectionCubit.state.isSelectionMode) {
      if (imagesSelectionCubit.state.selected.contains(image)) {
        imagesSelectionCubit.removeAll([image]);

        if (imagesSelectionCubit.state.selected.isEmpty) {
          imagesSelectionCubit.disableSelection();
        }
      } else {
        imagesSelectionCubit.addAll([image]);
      }
    } else {
      pushRoute(
          context: context,
          screen: ImageView(
            parentKey:
                _imageViewType == ImageViewType.userFavorite ? _key : null,
            showInfo: widget.data.showInfo,
            initialIndex: index,
            images: images,
            imageViewType: _imageViewType,
          ));
    }
  }

  ImageViewType get _imageViewType {
    return widget.data.imageViewType;
  }

  void _handleAddImages() async {
    var images = await ImagePicker().pickMultiImage();
    if (images == null) {
      EasyLoading.showInfo(
        'No image was selected.',
      );
      return;
    }
    final files = <String, File>{};
    int i = 0;
    for (var image in images) {
      files['$i'] = File(image.path);
      i++;
    }
    if (widget.data.subjectId.startsWith('nm')) {
      var resp = await uploadPersonImagesApi(widget.data.subjectId, files);
      if (resp['code'] == 200) {
        EasyLoading.showInfo(
          'Successfully uploaded ${resp['result'].length} images!',
        );
      }
    }
  }

  int t1 = 0;
  int t2 = 0;
  double _lastOffset = 0.0;
  // var _locked = false;
  final Lock _lock = Lock();
  void _listenScrollVelocity() async {
    // if (_locked) {
    //   return;
    // }
    // _locked = true;
    await _lock.synchronized(() async {
      if (!_controller.hasClients) {
        return;
      }
      // await Future.delayed(const Duration(milliseconds: 200));

      t2 = DateTime.now().millisecondsSinceEpoch;
      var nowOffset = _controller.position.pixels;
      var speed = (nowOffset - _lastOffset) / (t2 - t1);
      if (speed.toString() == 'NaN') {
        return;
      }
      // printInfo(info: 'speed = $speed');
      var threshold = 2;
      if ((speed.abs()) > threshold) {
        try {
          // Get.find<JumpToTopBottomController>().type.value = 'bottom';//todo
          await Future.delayed(const Duration(seconds: 3));
          // Get.find<JumpToTopBottomController>().type.value = '';//todo
        } catch (e) {}
        // await Future.delayed(const Duration(milliseconds: 2000));
      }
      //  else if (speed < -threshold) {
      //   Get.find<JumpToTopBottomController>().type.value = 'top';
      // }
      // else {
      //   Get.find<JumpToTopBottomController>().type.value = '';
      // }
      _lastOffset = nowOffset;
      t1 = t2;
    });
    // _locked = false;
  }

  void _toggleSelectAll(BuildContext context) {
    var cubit = context.read<ImagesSelectionCubit>();
    if (cubit.state.selected.length < _all.length) {
      cubit.setState(ImagesSelectionState(_all, true));
    } else {
      cubit.setState(const ImagesSelectionState([], false));
    }
  }

  void _handleFavPhotos(BuildContext context) {
    var cubit = context.read<ImagesSelectionCubit>();
    var selected = cubit.state.selected;
    if (selected.isEmpty) {
      return;
    }
    _key.currentState?.removeCurrentMaterialBanner();
    _key.currentState?.showMaterialBanner(MaterialBanner(
        content: Text(_imageViewType == ImageViewType.userFavorite
            ? 'Remove ${selected.length} photo(s) from your favorite?'
            : 'Add ${selected.length} photo(s) to your favorite?'),
        actions: [
          TextButton(
              onPressed: () async {
                var favPhotosCopy =
                    []; //todo Get.find<UserFavPhotosController>().photos.toList();
                var selectedCopy = selected.toList();
                _key.currentState?.hideCurrentMaterialBanner();
                if (_imageViewType == ImageViewType.userFavorite) {
                  var success = await deleteUserFavPhotoApi(selected);

                  await updateUserFavPhotos(context);
                  debugPrint('statement114545787');

                  //todo
                  // _imagesCountController.count.value =
                  //     Get.find<UserFavPhotosController>().photos.length;
                  // _all = Get.find<UserFavPhotosController>().photos;
                  // selected.clear();
                  // _selectionController.isSelectionMode = false;//todo

                  if (success) {
                    _key.currentState?.hideCurrentSnackBar();
                    _key.currentState?.showSnackBar(
                        await buildFavPhotoDelSuccessSnackbar(
                            context: context,
                            photosToUndo: selectedCopy
                                .where((p0) => favPhotosCopy.contains(p0))
                                .toList()));
                  } else {
                    _key.currentState?.hideCurrentSnackBar();
                    _key.currentState?.showSnackBar(
                        const SnackBar(content: Text('Delete failed')));
                  }
                } else {
                  var success = await addUserFavPhotoApi(selected);
                  updateUserFavPhotos(context);
                  if (success) {
                    _key.currentState?.showSnackBar(
                        buildFavPhotoAddSuccessSnackBar(context,
                            preventDuplicates: false, length: selected.length));
                  }
                }
              },
              child: const Text('OK')),
          TextButton(
              onPressed: () {
                _key.currentState?.hideCurrentMaterialBanner();
              },
              child: const Text('Cancel'))
        ]));
  }
}

class SubjectPhotosCountWidget extends StatefulWidget {
  const SubjectPhotosCountWidget(
      {super.key, required this.subjectId, required this.allLength});
  final String subjectId;
  final int allLength;
  @override
  State<SubjectPhotosCountWidget> createState() =>
      _SubjectPhotosCountWidgetState();
}

class _SubjectPhotosCountWidgetState extends State<SubjectPhotosCountWidget> {
  late final Future<int?> _future;
  @override
  void initState() {
    super.initState();
    _future = getPicsCountApi(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
        future: _future,
        builder: (context, snapshot) {
          return Text(
              '${widget.allLength} of ${max(snapshot.data ?? 0, widget.allLength)} photos');
        });
  }
}
