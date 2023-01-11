import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/cubit/top_movie_card_page_index_cubit.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../apis/apis.dart';
import '../beans/details.dart';
import '../screens/movie_detail/top_movie_card_long.dart';
import '../utils/platform.dart';
import '../utils/string/string_utils.dart';
import '../widget_methods/widget_methods.dart';
import 'blured_background.dart';

class TopMovieCardsPageView extends StatefulWidget {
  const TopMovieCardsPageView({
    Key? key,
    // this.initialIndex = 0,
    // required this.movies,
    required this.title,
    required this.ids,
    required this.scrollController,
  }) : super(key: key);
  final String title;
  final List<String> ids;
  final AutoScrollController scrollController;

  @override
  State<TopMovieCardsPageView> createState() => _TopMovieCardsPageViewState();
}

class _TopMovieCardsPageViewState extends State<TopMovieCardsPageView> {
  // int cur = 0;
  @override
  void initState() {
    super.initState();
    debugPrint('_TopMovieCardsPageViewState initState');
    _getData();
    // cur = widget.initialIndex;
    _pageController ??= PageController(
        initialPage: context.read<TopMovieCardPageIndexCubit>().state,
        viewportFraction: 0.9);
  }

  @override
  void didUpdateWidget(covariant TopMovieCardsPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    // widget.scrollController.dispose();

    super.dispose();
  }

  // final String tag = Uuid().v4();
  PageController? _pageController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TopMovieCardPageIndexCubit>();
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (PlatformUtils.isDesktop) {
          widget.scrollController.scrollToIndex(cubit.state,
              preferPosition: AutoScrollPosition.middle);
        }
        return true;
      },
      child: PageView.builder(
          onPageChanged: (index) {
            // updateRecentViewed(movies[index].id!);
            cubit.set(index);
            if (!PlatformUtils.isDesktop) {
              widget.scrollController.scrollToIndex(index,
                  preferPosition: AutoScrollPosition.middle);
            }
          },
          controller: _pageController,
          itemCount: widget.ids.length,
          itemBuilder: (context, index) {
            // var movie = movies[index];
            return widget.ids.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: TopMovieCardLongBlurredLazy(
                            id: widget.ids[index], title: widget.title)),
                  )
                : const SizedBox();
          }),
    );
  }

  bool _loading = false;
  void _getData() async {
    _loading = true;
    if (mounted) {
      setState(() {});
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
    }
    _loading = false;
  }
}

class TopMovieCardLongBlurredLazy extends StatefulWidget {
  const TopMovieCardLongBlurredLazy(
      {Key? key, required this.title, required this.id})
      : super(key: key);
  final String title;
  final String id;

  @override
  State<TopMovieCardLongBlurredLazy> createState() =>
      _TopMovieCardLongBlurredLazyState();
}

class _TopMovieCardLongBlurredLazyState
    extends State<TopMovieCardLongBlurredLazy>
    with AutomaticKeepAliveClientMixin<TopMovieCardLongBlurredLazy> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant TopMovieCardLongBlurredLazy oldWidget) {
    if (oldWidget.id != widget.id) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_movieBean == null) {
      return const SizedBox();
    }
    return TopMovieCardLongBlurred(movie: _movieBean!, title: widget.title);
  }

  MovieBean? _movieBean;
  void _getData() async {
    var movieDetailsResp = await getMovieDetailsApi([widget.id]);
    try {
      _movieBean = movieDetailsResp!.result!.first;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // TODO
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class TopMovieCardLongBlurred extends StatelessWidget {
  const TopMovieCardLongBlurred({
    Key? key,
    required this.movie,
    required this.title,
  }) : super(key: key);

  final MovieBean movie;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // width: screenWidth(context) * 0.5,
        child: BlurredBackground(
      backgroundImageUrl: smallPic(movie.cover),
      child: CustomScrollView(
        slivers: [
          if (!PlatformUtils.isDesktop)
            buildSingleChildSliverList(
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
            ),
          MovieDetailTopCardLongMultiSlivers(movieBean: movie),
        ],
      ),
    ));
  }
}
