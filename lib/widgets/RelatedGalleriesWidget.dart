import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import 'RelatedGalleryWidget.dart';

class RelatedGalleriesWidget extends StatefulWidget {
  const RelatedGalleriesWidget({
    Key? key,
    required List<String> gids,
  })  : _gids = gids,
        super(key: key);

  final List<String> _gids;

  @override
  State<RelatedGalleriesWidget> createState() => _RelatedGalleriesWidgetState();
}

class _RelatedGalleriesWidgetState extends State<RelatedGalleriesWidget> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 210,
          margin: const EdgeInsets.only(bottom: 10),
          child: CarouselSlider.builder(
            itemCount: widget._gids.length,
            itemBuilder: (context, index, realIndex) {
              return RelatedGalleryWidget(
                gid: widget._gids[realIndex],
              );
            },
            options: CarouselOptions(
                onPageChanged: ((index, reason) {
                  _currentPageNotifier.value = index;
                }),
                viewportFraction: 1,
                enableInfiniteScroll: false),
          ),
        ),
        SizedBox(
          height: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CirclePageIndicator(
              currentPageNotifier: _currentPageNotifier,
              itemCount: widget._gids.length,
            ),
          ),
        )
      ],
    );
  }
}
