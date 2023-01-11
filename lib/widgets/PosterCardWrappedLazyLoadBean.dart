import 'package:flutter/material.dart';

import '../apis/apis.dart';
import '../apis/basic_info.dart';
import '../beans/poster_bean.dart';
import '../constants/config_constants.dart';
import 'movie_poster_card.dart';

class PosterCardWrappedLazyLoadBean extends StatefulWidget {
  const PosterCardWrappedLazyLoadBean(
      {Key? key,
      required this.id,
      this.tinyImage = false,
      this.requireAge = false})
      : super(key: key);
  final String id;
  final bool tinyImage;
  final bool requireAge;

  @override
  State<PosterCardWrappedLazyLoadBean> createState() =>
      _PosterCardWrappedLazyLoadBeanState();
}

class _PosterCardWrappedLazyLoadBeanState
    extends State<PosterCardWrappedLazyLoadBean> {
  BasicInfo? _posterBean;

  Future _getPosterBean() async {
    // await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 100));
    try {
      _posterBean = (await getBasicInfoApi([widget.id])).first;
      if (widget.id.startsWith('nm') &&
          _posterBean?.age == 0 &&
          widget.requireAge) {
        var age = await getPersonAgeApi(widget.id);
        _posterBean?.age = age;
      }
    } catch (e) {
      debugPrint('$e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getPosterBean();
  }

  @override
  void didUpdateWidget(covariant PosterCardWrappedLazyLoadBean oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _getPosterBean();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_posterBean != null) {
      return PosterCard(
          yearRange: _posterBean!.yearRange?.replaceAll(RegExp(r'\(|\)'), ''),
          // requireAge: widget.requireAge,
          tinyImage: widget.tinyImage,
          age: _posterBean!.age,
          rate: double.tryParse(_posterBean!.rate!),
          posterUrl: _posterBean!.image,
          title: _posterBean!.title ?? '',
          id: _posterBean!.id!);
    }
    return PosterCard(
      // requireAge: widget.requireAge,
      id: widget.id,
      posterUrl: widget.id.startsWith('tt') ? defaultCover : defaultAvatar,
      title: '',
    );
  }
}
