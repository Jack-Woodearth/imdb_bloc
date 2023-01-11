import 'dart:math';

import 'package:flutter/material.dart';

import '../apis/apis.dart';
import '../beans/gallery.dart';
import 'ThreePicturesAndTextWidget.dart';

class RelatedGalleryWidget extends StatefulWidget {
  const RelatedGalleryWidget({
    Key? key,
    required this.gid,
  }) : super(key: key);
  final String gid;
  @override
  State<RelatedGalleryWidget> createState() => _RelatedGalleryWidgetState();
}

class _RelatedGalleryWidgetState extends State<RelatedGalleryWidget> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _onTap() {
    //todo
    // Get.to(() => GalleryScreen(
    //     gid: _imdbGalleries.first.gid!,
    //     galleryTitle: _imdbGalleries.first.galleryTitle!));
  }

  @override
  Widget build(BuildContext context) {
    if (_imdbGalleries.isEmpty) {
      return const SizedBox(
        child: CircularProgressIndicator(),
      );
    }

    var images = _imdbGalleries
        .sublist(0, min(3, _imdbGalleries.length))
        .map((e) => e.image!)
        .toList();
    var text = _imdbGalleries.first.galleryTitle!;
    return ThreePicturesAndTextWidget(
      text: text,
      pictures: images,
      onTap: _onTap,
    );
  }

  List<ImdbGallery> _imdbGalleries = [];
  void _getData() async {
    _imdbGalleries = await getGalleryApi(widget.gid);
    if (mounted) {
      setState(() {});
    }
  }
}
