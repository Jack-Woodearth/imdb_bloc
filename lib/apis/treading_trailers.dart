// Future<List<MovieTrailerBean>> getTrendingTrailersApi() async {
//   var resp = await MyDio().dio.get(baseUrl + '/trailers/trending');
//   if (reqSuccess(resp)) {
//     var isoRet = await CommonWorkerIsolate()
//         .requsetTask(parseGetTrendingTrailersApiJson, resp.data['result']);
//     List<MovieTrailerBean> trailers = isoRet.result;
//     return trailers;
//   }

//   return [];
// }

// Future<List<MovieTrailerBean>> getPopularTrailersApi() async {
//   var resp = await MyDio().dio.get(baseUrl + '/trailers/popular');
//   if (reqSuccess(resp)) {
//     var isoRet = await CommonWorkerIsolate()
//         .requsetTask(parseGetTrendingTrailersApiJson, resp.data['result']);
//     List<MovieTrailerBean> trailers = isoRet.result;
//     return trailers;
//   }

//   return [];
// }

// Future<List<MovieTrailerBean>> getAnticipatedTrailersApi() async {
//   var resp = await MyDio().dio.get(baseUrl + '/trailers/anticipated');
//   if (reqSuccess(resp)) {
//     var isoRet = await CommonWorkerIsolate()
//         .requsetTask(parseGetTrendingTrailersApiJson, resp.data['result']);
//     List<MovieTrailerBean> trailers = isoRet.result;
//     return trailers;
//   }

//   return [];
// }

// Future<List<MovieTrailerBean>> getRecentTrailersApi() async {
//   var resp = await MyDio().dio.get(baseUrl + '/trailers/recent');
//   if (reqSuccess(resp)) {
//     var isoRet = await CommonWorkerIsolate()
//         .requsetTask(parseGetTrendingTrailersApiJson, resp.data['result']);
//     List<MovieTrailerBean> trailers = isoRet.result;
//     return trailers;
//   }

//   return [];
// }

import 'package:flutter/foundation.dart';

import '../beans/details.dart';
import '../beans/movie_trailer.dart';
import '../beans/trailers_resp.dart';
import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';
import '../utils/isolates/common_woker_isolate.dart';

List<MovieTrailerBean> parseGetTrendingTrailersApiJson(js) {
  List<MovieTrailerBean> trailers = [];
  for (var item in js) {
    try {
      var t = Trailer.fromJson(item[1]);
      trailers.add(MovieTrailerBean(
        // mid: trailer[0]['mid'],
        // movieTitle: trailer[0]['title'],

        movieBean: MovieBean.fromJson(item[0]),
        trailerCover: t.videoRenderer!.thumbnail!.thumbnails!.first.url!,
        trailerTime: t.videoRenderer!.lengthText!.simpleText!,
        videoId: t.videoRenderer!.videoId!,
      ));
    } catch (e) {}
  }

  return trailers;
}

// void main(List<String> args) async {
//   var res = await getTrendingTrailersApi();
//   print(res);
// }

enum TrailersType {
  trending,
  popular,
  anticipated,
  recent,
}

Future<List<MovieTrailerBean>> getTrailersApi(TrailersType trailersType) async {
  var resp =
      await CacheDio().dio.get(baseUrl + '/trailers/${trailersType.name}');
  if (reqSuccess(resp)) {
    var isoRet =
        await compute(parseGetTrendingTrailersApiJson, resp.data['result']);
    List<MovieTrailerBean> trailers = isoRet;
    return trailers;
  }

  return [];
}
