import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../beans/news.dart';
import 'news_card.dart';

class NewsListScroll extends StatefulWidget {
  const NewsListScroll({
    Key? key,
    required this.newsList,
  }) : super(key: key);

  final List<NewsBean> newsList;

  @override
  State<NewsListScroll> createState() => _NewsListScrollState();
}

class _NewsListScrollState extends State<NewsListScroll> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [_buildPageView(), _buildCircleIndicator()],
      ),
    );
  }

  Widget _buildPageView() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: PageView.builder(
        controller: PageController(),
        onPageChanged: (index) {
          _currentPageNotifier.value = index;
        },
        scrollDirection: Axis.horizontal,
        itemCount: widget.newsList.length,
        itemBuilder: (BuildContext context, int index) {
          var news = widget.newsList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: NewsCard(
                newsBean: news,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: widget.newsList.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}
