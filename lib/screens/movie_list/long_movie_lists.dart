// import 'dart:math';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:imdb_bloc/beans/new_list_result_resp.dart';
// import 'package:imdb_bloc/constants/colors_constants.dart';
// import 'package:imdb_bloc/cubit/filter_button_cubit.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import '../../apis/get_movie_content_type.dart';
// import '../../beans/details.dart';
// import '../../utils/string/string_utils.dart';
// import '../../widgets/filter_buttons.dart';
// import '../../widgets/movie_poster_card.dart';
// import '../../widgets/my_network_image.dart';
// import '../user_profile/utils/you_screen_utils.dart';
// import '../user_profile/youscreen.dart';

// class LongMovieListScreen extends StatefulWidget {
//   const LongMovieListScreen(
//       {Key? key,
//       required this.title,
//       required this.movies,
//       this.total = 0,
//       this.ids = const [],
//       required this.onLoadMoreItems})
//       : super(key: key);
//   final String title;
//   final int total;
//   final List<String> ids;
//   final Future Function() onLoadMoreItems;
//   @override
//   State<LongMovieListScreen> createState() => _LongMovieListScreenState();
//   final List<MovieBean> movies;
// }

// class _LongMovieListScreenState extends State<LongMovieListScreen> {
//   final String tag = 'LongMovieListScreen';
//   // late FilterController filterController;

//   @override
//   Widget build(BuildContext context) {
//     var length = max(widget.ids.length, widget.movies.length);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: NotificationListener<ScrollEndNotification>(
//         onNotification: (notification) {
//           if (notification.metrics.pixels >=
//               notification.metrics.maxScrollExtent) {
//             widget.onLoadMoreItems();
//           }
//           return false;
//         },
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               forceElevated: true,
//               floating: true,
//               expandedHeight: 160,
//               leading: const SizedBox(),
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(widget.title),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'a list of $length titles ',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                     FilterButtons(
//                       tag: tag,
//                       onFilterChanged: () {},
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       // child: Text(
//                       //     '${max(widget.ids.length, max(widget.movies.length, widget.total))} Titles'),
//                       child: Builder(builder: (_) {
//                         int cnt = 0;
//                         // for (var m in widget.movies) {
//                         //   if (filtered(context.read<SubjectBloc>(), m)) {
//                         //     cnt += 1;
//                         //   }
//                         // }
//                         return AutoSizeText(
//                           '$cnt titles loaded',
//                           maxLines: 1,
//                           minFontSize: 10,
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverList(
//                 delegate: SliverChildBuilderDelegate(((context, index) {
//               return Builder(builder: (context) {
//                 var m = widget.movies[index];
//                 //todo
//                 // if (!filtered(filterController, m)) {
//                 //   return const SizedBox(
//                 //     height: 0,
//                 //   );
//                 // }

//                 return Column(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         //todo
//                         // Get.to(() => MovieFullDetailScreen(movieBean: m));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: SizedBox(
//                           height: 160,
//                           child: Row(
//                             children: [
//                               PosterWithOutTitle(posterUrl: m.cover, id: m.id!),
//                               Expanded(
//                                 flex: 4,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         '#${index + 1}',
//                                         style: const TextStyle(fontSize: 15),
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       SizedBox(
//                                         // width: screenWidth(context) * 0.2,
//                                         child: AutoSizeText(
//                                           '${m.title}',
//                                           maxLines: 2,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .titleMedium
//                                               ?.copyWith(
//                                                   fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Row(
//                                         children: [
//                                           if (!widget.title
//                                               .toLowerCase()
//                                               .contains('coming soon')) ...[
//                                             Icon(
//                                               Icons.star_rounded,
//                                               color: ImdbColors.themeYellow,
//                                             ),
//                                             Text(
//                                                 '${m.rateDouble.toStringAsFixed(1)}  '),
//                                           ],
//                                           Text(
//                                               '${m.yearRange}  ${m.runtime}min')
//                                         ],
//                                       ),
//                                       if (m.directors?.isNotEmpty == true)
//                                         MovieInfoItemWidget(
//                                           cat: 'Director ',
//                                           value:
//                                               '${m.directors?.map((e) => e.name).join(' / ')}',
//                                         ),
//                                       if (m.stars?.isNotEmpty == true)
//                                         MovieInfoItemWidget(
//                                             cat: 'Stars ',
//                                             value:
//                                                 '${m.stars?.map((e) => e.name).join(' / ')}'),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   InkWell(
//                                       onTap: () {
//                                         _handleDotsTap(context, m);
//                                       },
//                                       child: const Icon(Icons.more)),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Divider()
//                   ],
//                 );
//               });
//             }), childCount: widget.movies.length)),
//             const SliverToBoxAdapter(child: ListLoadingIndicator()),
//             const SliverToBoxAdapter(
//                 child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('The end.'),
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<dynamic> _handleDotsTap(BuildContext context, MovieBean m) {
//     return showBarModalBottomSheet(
//         backgroundColor: Theme.of(context).canvasColor,
//         context: context,
//         builder: (context) {
//           return SizedBox(
//             height: 250,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Card(
//                       // color: Theme.of(context).cardColor,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: SizedBox(
//                                 width: 70,
//                                 // height: double.infinity,
//                                 // height: 90,
//                                 child: AspectRatio(
//                                   aspectRatio: 2 / 3,
//                                   child: MyNetworkImage(
//                                     url: smallPic(m.cover),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       child: Text(
//                                         '${m.title}',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleMedium,
//                                       ),

//                                       // width: screenWidth(context) * 0.5,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.star_rounded,
//                                           color: ImdbColors.themeYellow,
//                                         ),
//                                         Text(m.rateDouble.toStringAsFixed(1)),
//                                         Text(
//                                             '  ${m.yearRange}  ${m.runtime}min')
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         //todo
//                         // Get.to(() => RateMovieScreen(movieBean: m));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: const [
//                             Text(
//                               'Rate title',
//                               // style: TextStyle(fontSize: 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         //todo
//                         // Get.to(() => SelectListScreen(subjectId: m.id!));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: const [
//                             Text(
//                               'Add to list',

//                               // style: TextStyle(fontSize: 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ]),
//             ),
//           );
//         });
//   }
// }

// class MovieInfoItemWidget extends StatelessWidget {
//   const MovieInfoItemWidget({
//     Key? key,
//     required this.cat,
//     required this.value,
//   }) : super(key: key);
//   final String cat;
//   final String value;
//   // final MovieBean m;

//   @override
//   Widget build(BuildContext context) {
//     return Text.rich(
//       TextSpan(children: [
//         TextSpan(
//           text: cat,
//           style: (const TextStyle(fontWeight: FontWeight.w600)),
//         ),
//         TextSpan(
//             text: value,
//             style: const TextStyle(overflow: TextOverflow.ellipsis))
//       ]),
//       maxLines: 2,
//     );
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           cat,
//           style: (const TextStyle(fontWeight: FontWeight.w600)),
//         ),
//         Expanded(
//           child: AutoSizeText(
//             value,
//             maxLines: 2,
//             minFontSize: 5,
//             textAlign: TextAlign.end,
//           ),
//         )
//       ],
//     );
//   }
// }

// class ListLoadingIndicator extends StatelessWidget {
//   const ListLoadingIndicator({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //todo
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }
// }
