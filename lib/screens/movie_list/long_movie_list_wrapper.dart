// import 'dart:math';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// import '../../apis/apis.dart';
// import '../../beans/details.dart';
// import 'long_movie_lists.dart';

// class LongMovieListWrapper extends StatefulWidget {
//   const LongMovieListWrapper(
//       {Key? key,
//       required this.ids,
//       required this.title,
//       this.total = 0,
//       this.fromSearchPage = false,
//       this.nextHref})
//       : super(key: key);
//   final List<String> ids;
//   final String title;
//   final int total;
//   final bool fromSearchPage;
//   final String? nextHref;
//   @override
//   State<LongMovieListWrapper> createState() => _LongMovieListWrapperState();
// }

// class _LongMovieListWrapperState extends State<LongMovieListWrapper> {
//   @override
//   void initState() {
//     super.initState();

//     next = widget.nextHref;
//     _init();
//   }

//   String? next;
//   @override
//   void didUpdateWidget(LongMovieListWrapper oldWidget) {
//     if (oldWidget.ids != widget.ids) {
//       _init();
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   _init() {
//     i = 0;
//     movies.clear();
//     loading = false;
//     lock.unlock();
//     _getData();
//   }

//   List<MovieBean> movies = [];
//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? const Center(child: CircularProgressIndicator())
//         : (movies.isEmpty
//             ? const Center(
//                 child: Text('Empty'),
//               )
//             : LongMovieListScreen(
//                 onLoadMoreItems: _getData,
//                 title: widget.title,
//                 movies: movies,
//                 ids: widget.ids,
//                 total: widget.total,
//               ));
//   }

//   int i = 0;

//   Future getMoreSearchResultMovieIds() async {
//     // await Future.delayed(const Duration(seconds: 1));
//     loading = true;
//     // EasyLoading.show(
//     //   status: 'getMoreSearchResultMovies',
//     // );
//     // Get.find<ListLoadingIndicatorController>().loading.value = true;
//     if (/*movies.length < widget.total*/ next != null) {
//       var newMovieListResultRespResult = await getListResultApi(next!);
//       widget.ids.addAll(newMovieListResultRespResult?.movies
//               ?.where((element) => element != null)
//               .map((e) => e!.id)
//               .toList() ??
//           []);
//       next = newMovieListResultRespResult?.next;
//     } else {
//       EasyLoading.showInfo('No more search results');
//     }
//     EasyLoading.dismiss();
//     // Get.find<ListLoadingIndicatorController>().loading.value = false;
//     loading = false;
//     // Get.find<ListGetxController>().needData.value = false;
//   }

//   bool loading = false;
//   Lock lock = Lock();
//   Future<void> _getData() async {
//     if (loading || lock.locked) {
//       return;
//     }
//     loading = true;
//     lock.lock();
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (i >= widget.ids.length) {
//       // print('i >= widget.ids.length');
//       if (widget.fromSearchPage) {
//         await getMoreSearchResultMovieIds();
//       } else {
//         return;
//       }
//     }

//     // Get.find<ListLoadingIndicatorController>().loading.value = true;
//     await Future.delayed(const Duration(milliseconds: 100));
//     var resp = await getMovieDetailsApi(
//         widget.ids.sublist(i, min(i + 20, widget.ids.length)));
//     i = min(i + 20, widget.ids.length);
//     // printInfo(info: 'getdata $i');
//     movies.addAll(resp != null && resp.result != null ? resp.result! : []);
//     // Get.find<ListGetxController>().needData.value = false;
//     // EasyLoading.dismiss();
//     // Get.find<ListLoadingIndicatorController>().loading.value = false;
//     loading = false;
//     lock.unlock();
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }
