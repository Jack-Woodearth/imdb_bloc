// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:imdb/apis/user_lists.dart';
// import 'package:imdb/beans/list_resp.dart';
// import 'package:imdb/screens/long_movie_lists/long_movie_list_wrapper.dart';
// import 'package:imdb/screens/movie_full_detail/all_images.dart';
// import 'package:imdb/screens/person/person_list_screen.dart';
// import 'package:imdb/utils/enums.dart';
// import 'package:imdb_bloc/screens/all_cast/all_cast.dart';

// import '../../beans/details.dart';
// import '../../beans/list_resp.dart';
// import '../../enums/enums.dart';
// import '../all_images/all_images.dart';

// class UserListDetailsScreen extends StatefulWidget {
//   const UserListDetailsScreen(
//       {Key? key,
//       // required this.title,
//       // required this.listUrl,
//       // required this.isPeopleList,
//       required this.listResult})
//       : super(key: key);
//   // final String title;
//   // final String listUrl;
//   // final bool isPeopleList;
//   final ListResult listResult;
//   @override
//   State<UserListDetailsScreen> createState() => _UserListDetailsScreenState();
// }

// class _UserListDetailsScreenState extends State<UserListDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }

//   @override
//   void didUpdateWidget(covariant UserListDetailsScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.listResult.listUrl != widget.listResult.listUrl) {
//       _getData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var listName = '${widget.listResult.listName}';
//     if (widget.listResult.isPictureList == true) {
//       return AllImagesScreen(
//         data: AllImagesScreenData(
//           imageViewType: ImageViewType.listPicture,
//           subjectId: '',
//           title: widget.listResult.listName ?? '',
//           pictures: widget.listResult.pictures,
//         ),
//       );
//     }

//     if (!(widget.listResult.isPeopleList == true)) {
//       return LongMovieListWrapper(
//           total: _ids!.length,
//           ids: _ids!,
//           title: widget.listResult.listName ?? '');
//       // return LongMovieListScreen(movies: _details ?? [], title: listName);
//     }
//     return PersonListScreen(
//         count: _ids?.length ?? 0, title: listName, ids: _ids ?? []);
//   }

//   List<MovieBean>? _details;
//   List<String>? _ids;
//   _getData() async {
//     // var resp = await getListDetailApi(widget.listUrl,
//     //     isPeopleList: widget.isPeopleList);
//     if (!(widget.listResult.isPictureList == true)) {
//       var mids = widget.listResult.mids;
//       if (mids == null) {
//         var listResp = await getListDetailApi(widget.listResult.listUrl);
//         mids = listResp.result?.mids ?? [];
//       }
//       _ids = mids;
//       // if (widget.listResult.isPeopleList == true) {
//       // } else {
//       //   var movieDetailsResp = await getMovieDetailsApi(mids);
//       //   _details = movieDetailsResp?.result;
//       // }
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }
// }
