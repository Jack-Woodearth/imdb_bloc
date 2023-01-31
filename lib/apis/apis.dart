import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/beans/recent_viewed_bean.dart';
import 'package:imdb_bloc/cubit/user_rated_cubit.dart';
import 'package:imdb_bloc/cubit/user_recently_viewed_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/singletons/user.dart';
import 'package:imdb_bloc/utils/db/db.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/sp/sp_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../beans/details.dart';
import '../beans/gallery.dart';
import '../beans/home_resp.dart';
import '../beans/new_list_result_resp.dart';
import '../beans/news.dart';
import '../beans/popular_genres_resp.dart';
import '../beans/reviews.dart';
import '../beans/sign_in_user.dart';
import '../beans/trailers_resp.dart';
import '../beans/user_rated_titles.dart';
import '../beans/user_ratings.dart';
import '../constants/config_constants.dart';
import '../constants/db_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';
import '../utils/string/string_utils.dart';
import 'list_repr_images_api.dart';
import 'person_bean_v2.dart';
import 'watchlist_api.dart';

Future<HomeResp?> getHomePage() async {
  HomeResp? homeResp;
  var t1 = DateTime.now();

  try {
    var res = await MyDio().dio.get(baseUrl);
    var t3 = DateTime.now();
    dp('getHomePage http request took ${t3.millisecondsSinceEpoch - t1.millisecondsSinceEpoch}ms');

    homeResp =
        await compute(HomeResp.fromJson, res.data as Map<String, dynamic>);
    // HomeResp.fromJson(res.data as Map<String, dynamic>);

    var t4 = DateTime.now();
    dp('getHomePage compute took ${t4.millisecondsSinceEpoch - t3.millisecondsSinceEpoch}ms');
  } catch (e) {}
  var t2 = DateTime.now();
  if (isDebug) {
    dp('getHomePage took:${t2.millisecondsSinceEpoch - t1.millisecondsSinceEpoch}ms');
  }
  return homeResp;
}

Future<MovieDetailsResp?> getMovieDetailsApi(List<String> mids,
    {bool queryLocal = true, List<String> fields = const []}) async {
  if (mids.isEmpty) {
    return null;
  }
  var db = await getDb();
  var local = await db.rawQuery(
      'select $jsonTablePK,$jsonTableJson from $jsonTable where id in (${mids.map(
            (e) => '\'$e\'',
          ).toList().join(',')})');
  // print(local);
  var idsStr = '';
  var idsLocal = local.map((e) => e[jsonTablePK]).toList();
  List<MovieBean> moviesLocal = await compute(convertToMoviesBeans, local);
  for (var element in mids) {
    if (!element.startsWith('tt')) {
      return null;
    }
    idsStr += '$element-';
  }
  // idsStr = idsStr.substring(0, idsStr.lastIndexOf('-'));
  idsStr = mids.toSet().difference(idsLocal.toSet()).toList().join('-');
  if (queryLocal == false) {
    idsStr = mids.join('-');

    moviesLocal = [];
  }
  if (idsStr == '') {
    // 保证顺序一致
    var sorted = <MovieBean>[];
    for (var id in mids) {
      for (var m in moviesLocal) {
        if (id == m.id) {
          sorted.add(m);
          break;
        }
      }
    }
    if (queryLocal) {
      return MovieDetailsResp(result: sorted);
    }
  }

  var resp = await MyDio().dio.get('$baseUrl/details', queryParameters: {
    'ids': idsStr,
    if (fields.isNotEmpty) 'fields': fields.join(',')
  });

  var t1 = DateTime.now();
  var ret = await compute(
    MovieDetailsResp.fromJson,
    resp.data as Map<String, dynamic>,
  );
  // var ret = MovieDetailsResp.fromJson(resp.data as Map<String, dynamic>);
  var t2 = DateTime.now();

  moviesLocal.addAll(ret.result ?? []);

  //update local db
  if (fields.isEmpty) {
    for (MovieBean item in ret.result ?? []) {
      try {
        db.delete(jsonTable, where: 'id=?', whereArgs: [item.id]);
        db.insert(jsonTable,
            {jsonTablePK: item.id, jsonTableJson: jsonEncode(item.toJson())});
      } catch (e) {
        dp('sjdhajkhdkjahsdkjhaj $e');
      }
    }
  }
  // 保证顺序一致
  var sorted = <MovieBean>[];
  for (var id in mids) {
    for (var m in moviesLocal) {
      if (id == m.id) {
        sorted.add(m);
        break;
      }
    }
  }
  return MovieDetailsResp(result: sorted, code: 200);
}

List<MovieBean> convertToMoviesBeans(List<Map<String, Object?>> local) {
  var moviesLocal = local
      .map((e) => MovieBean.fromJson(
          jsonDecode(e[jsonTableJson] as String) as Map<String, dynamic>))
      .toList();
  return moviesLocal;
}

Future<List<PersonBean>?> getPersonDetailsApi(List<String> ids) async {
  var db = await getDb();
  var local = await db.rawQuery(
      'select $jsonTablePK,$jsonTableJson from $jsonTablePersonBasicInfo where id in (${ids.map(
            (e) => '\'$e\'',
          ).toList().join(',')})');
  var idsLocal = local.map((e) => e[jsonTablePK]).toList();
  var peopleLocal = local
      .map((e) => PersonBean.fromJson(
          jsonDecode(e[jsonTableJson] as String) as Map<String, dynamic>))
      .toList();
  var idsStr = makeIdsString(
      ids.toSet().difference(idsLocal.toSet()).toList(), 'nm', '-');
  if (idsStr == '' || idsStr == null) {
    // 保证顺序一致
    var sorted = <PersonBean>[];
    for (var id in ids) {
      for (var m in peopleLocal) {
        if (id == m.id) {
          sorted.add(m);
          break;
        }
      }
    }
    return sorted;
  }
  try {
    var resp = await MyDio()
        .dio
        .get('$baseUrl/persons', queryParameters: {'ids': idsStr});
    var ret = <PersonBean>[];
    if (resp.data['result'] != null) {
      for (var item in resp.data['result']) {
        var personRet =
            await compute(PersonBean.fromJson, item as Map<String, dynamic>);
        ret.add(personRet);
        try {
          db.insert(jsonTablePersonBasicInfo,
              {jsonTablePK: personRet.id, jsonTableJson: jsonEncode(item)});
        } catch (e) {
          dp('dakjsooopopp $e');
        }
      }
    }
    var sorted = <PersonBean>[];
    for (var id in ids) {
      for (var m in ret) {
        if (id == m.id) {
          sorted.add(m);
          break;
        }
      }
    }
    return sorted;
  } catch (e) {
    dp('89898.2323487.kjn9 getPersonDetailsApi error $e');

    return null;
  }
}

Future<PersonResult?> getPersonFullDetailApi(String pid,
    {bool queryLocal = false}) async {
  var db = await getDb();
  if (queryLocal) {
    var local = await db
        .rawQuery('select * from $jsonTable where $jsonTablePK = \'$pid\' ');
    if (local.isNotEmpty) {
      var localPersonBean = PersonResult.fromJson(
          jsonDecode(local.first[jsonTableJson] as String));
      return localPersonBean;
    }
  }
  var resp = await MyDio().dio.get('$baseUrl/person/$pid');
  var data = resp.data['result'];
  if (data == null) {
    return null;
  }
  var ret = await compute(
    PersonResult.fromJson,
    data as Map<String, dynamic>,
  );
  try {
    await db.rawQuery('delete from $jsonTable where $jsonTablePK = \'$pid\' ');
    db.insert(jsonTable, {jsonTablePK: pid, jsonTableJson: jsonEncode(data)});
  } catch (e) {
    dp('dnjakskdhakj.kjn9 getPersonDetailsApi error $e');
  }
  return ret;
}

Future<List<NewsBean>?> getNewsApi(String nids) async {
  try {
    var preferences = await SharedPreferences.getInstance();
    var key = 'getNewsApi:$nids';
    var string = preferences.getString(key);
    if (string != null) {
      var newsResp = NewsResp.fromJson(jsonDecode(string));
      return newsResp.result;
    }
    var resp = await MyDio().dio.get('$baseUrl/news/$nids');
    if (reqSuccess(resp)) {
      var newsResp = NewsResp.fromJson(resp.data);
      preferences.setString(key, jsonEncode(newsResp.toJson()));
      var ret = newsResp.result;
      return ret;
    }
  } catch (e) {
    print('ashdlakjldkjal $e');
  }
  return null;
}

Future<List<GenreCateory>> getPopularGenresApi() async {
  var resp = await MyDio().dio.get('$baseUrl/popular_genre');
  if (reqSuccess(resp)) {
    return PopularGenreResp.fromJson(resp.data).result ?? [];
  }
  return [];
}

Future<NewMovieListRespResult?> advancedSearchApi(Map data,
    {int start = 1}) async {
  print('$data');
  if (data.length == 1 && data['Title'] == '') {
    return null;
  }
  var resp = await BasicDio()
      .dio
      .post('$baseUrl/search/movies/advanced?start=$start', data: data);

  var result2 = NewMovieListResultResp.fromJson(resp.data).result;
  if (result2?.movies?.isNotEmpty != true) {}
  return result2;
}

Future<NewMovieListRespResult?> simpleSearchApi(String title,
    {int page = 1}) async {
  var resp = await BasicDio().dio.get('$baseUrl/search/movies/simple',
      queryParameters: {'title': title, 'page': page});

  var result2 = NewMovieListResultResp.fromJson(resp.data).result;
  if (result2?.movies?.isNotEmpty != true) {}
  return result2;
}

Future<NewMovieListRespResult?> getListResultByHrefApi(String href) async {
  var resp = await MyDio()
      .dio
      .get('$baseUrl/list_result', queryParameters: {'href': href});

  return NewMovieListResultResp.fromJson(resp.data).result;
}

Future<String> getPlotApi(String mid) async {
  var resp = await CacheDio().dio.get('$baseUrl/plot/$mid');
  return resp.data['result'] ?? '';
}

class ReviewsHandler {
  String mid;
  ReviewsHandler({required this.mid});
  Future<bool> add(Review review) async {
    review.authorId = user.uid;
    var response = await MyDio().dio.post(url, data: review.toJson());
    return response.data['code'] == 200;
  }

  String get url => '$baseUrl/reviews/$mid';

  Future<bool> delete(List<int> ids) async {
    var response =
        await MyDio().dio.delete(url, queryParameters: {'ids': ids.join('-')});
    return response.data['code'] == 200;
  }

  Future<bool> update(Review review) async {
    var response = await MyDio().dio.put(url,
        queryParameters: {
          'review_id': review.id,
        },
        data: review.toJson());
    return response.data['code'] == 200;
  }

  Future<List<Review>> list() async {
    var resp = await MyDio().dio.get(url);
    return ReviewsResp.fromJson(resp.data).result ?? [];
  }
}

Future voteForReviewApi(int reviewId, {int like = 1}) async {
  var resp =
      await MyDio().dio.post('$baseUrl/reviews_vote/$reviewId?like=$like');
  return resp.data['result'];
}

Future<UserReviewVote?> getUserVoteForReviewApi(int reviewId) async {
  try {
    var resp = await MyDio().dio.get('$baseUrl/reviews_vote/$reviewId');
    return UserReviewVote.fromJson(resp.data['result']);
  } catch (e) {
    return null;
  }
}

Future<List<UserReviewVote>> batchGetUserVoteForReviewsApi(
    List<int> ids) async {
  try {
    var resp =
        await MyDio().dio.get('$baseUrl/reviews_vote?ids=${ids.join('-')}');
    var ret = <UserReviewVote>[];
    for (var item in resp.data['result']) {
      ret.add(UserReviewVote.fromJson(item));
    }
    return ret;
  } catch (e) {
    dp('dasjdjalkjlk $e');
    return [];
  }
}

Future<UserRatingsResp?> getUserRatingsApi(String mid) async {
  try {
    var data = await MyDio().get('$baseUrl/ratings/$mid');
    return UserRatingsResp.fromJson(data);
  } catch (e) {
    return null;
  }
}

Future<UserRatedTitle?> rateMovieApi(String mid, int rate) async {
  try {
    var resp = await MyDio().dio.post('$baseUrl/rate/$mid?rate=$rate');
    return UserRatedTitle.fromJson(resp.data['result']);
  } catch (e) {
    return null;
  }
}

Future<int?> getUserPersonalRateApi(String mid) async {
  var resp = await MyDio().dio.get('$baseUrl/rate/$mid');
  return resp.data['result'];
}

Future<List<UserRatedTitle>> getUserRatedTitlesApi() async {
  try {
    var response = await MyDio().dio.get('$baseUrl/rate');

    var list = UserRatedTitlesResp.fromJson(response.data).result ?? [];

    return list;
  } catch (e) {
    return [];
  }
}

Future<Response> removeRateApi(String mid) async {
  var resp = await MyDio().dio.delete('$baseUrl/rate/$mid');
  // getUserRatedTitlesApi();
  return resp;
}

Future<List<Trailer>> getTrailersApi(String mid) async {
  dp('getTrailersApi $mid');
  if (isBlank(mid)) {
    return [];
  }
  var resp = await CacheDio().dio.get('$baseUrl/trailers/$mid');
  if (reqSuccess(resp)) {
    return TrailersResp.fromJson(resp.data).result ?? [];
  }
  return [];
}

Future<List<ImdbGallery>> getGalleryApi(String gid) async {
  var resp = await MyDio().get('$baseUrl/gallery?gid=$gid');
  return GalleryResp.fromJson(resp).result ?? [];
}

Future<List<String>> getGalleriesCovers(List<String> gids) async {
  List<Future<List<ImdbGallery>>> futures = [];
  for (var gid in gids) {
    futures.add(getGalleryApi(gid));
  }
  var list = await Future.wait(futures);
  return list
      .where((element) => element.isNotEmpty)
      .where((element) => element.first.image != null)
      .map((e) => e.first.image!)
      .toList();
}

Future<List<String>> getWebpageImages(String url) async {
  if (url.startsWith('$imdbHomeUrl/list/')) {
    var s = RegExp(r'/list/ls\d+').firstMatch(url)?.group(0);
    if (s != null) {
      var images = await getListReprImagesApi(s);
      return images;
    }
  }
  var resp = await Dio().get(
      '$baseUrl/get_webpage_images?url=${base64.encode(utf8.encode(url))}');
  return resp.data['result'].cast<String>();
}

Future<int?> getPersonAgeApi(String id) async {
  var response = await MyDio().get('$baseUrl/person/$id/age');
  var age = response['result'];
  return age;
}

///采用mids时page和listUrl无效，反之亦然
Future<NewMovieListRespResult?> getNewListMoviesApi(
    {String? listUrl, int? page, List<String> mids = const []}) async {
  if (isBlank(listUrl) && mids.isEmpty) {
    return null;
  }
  var resp = await MyDio().dio.get('$baseUrl/new_list/movies',
      queryParameters: {
        'list_url': listUrl,
        'page': page ?? 1,
        'mids': mids.join('-')
      });
  var result2 = NewMovieListResultResp.fromJson(resp.data).result;

  return result2;
}

class SignInApis {
  static Future<dynamic> getEmailCode(String email,
      {required String captchaCode, required String captchaId}) async {
    if (!isEmail(email)) {
      return null;
    }

    var response =
        await ImdbWithCaptchaDio(captchaCode: captchaCode, captchaId: captchaId)
            .dio
            .post('$userUrl/ajax_send_email_verification_code',
                data: {'uid': user.uid, 'to': email});

    return response.data;
  }

  static Future<Response> register(SignInUser user) async {
    var resp = await Dio().post('$userUrl/ajax_signup', data: {
      'username': user.username,
      'password': user.password,
      'email': user.email,
      'email_code': user.emailCode
    });
    return resp;
  }

  static Future<Response> login(SignInUser user) async {
    var resp = await BasicDio().dio.post('$userUrl/ajax_login', data: {
      'username': user.username,
      'password': user.password,
      'email': user.email,
      'email_code': user.emailCode
    });
    return resp;
  }

  static Future<Response> getUsernameByEmail(String email,
      {String? captchaId, String? captcha}) async {
    var resp = await BasicDio().dio.get('$userUrl/get_username_by_email',
        queryParameters: {
          'email': email,
          'captcha_id': captchaId,
          'captcha_code': captcha
        });
    return resp;
  }
}

UserRatedTitle? getRate(String mid, BuildContext context) {
  for (var title in context.read<UserRatedCubit>().state.titles) {
    if (title.mid == mid) {
      return title;
    }
  }
  return null;
}

bool isRated(String mid, BuildContext context) {
  for (var title in context.read<UserRatedCubit>().state.titles) {
    if (title.mid == mid) {
      return true;
    }
  }
  return false;
}

bool isFavPeopleOrInWatchList(String id, BuildContext context) {
  return context.read<UserWatchListCubit>().state.ids.contains(id) ||
      context.read<UserFavPeopleCubit>().state.ids.contains(id);
}

Future<void> updateRecentViewed(String id, BuildContext context) async {
  var recentlyViewedCubit = context.read<UserRecentlyViewedCubit>();
  var resp =
      await MyDio().dio.post('$baseUrl/recent?id=$id', options: getAuth());
  if (reqSuccess(resp)) {
    var recent = RecentViewedBean.fromJson(resp.data['result']);
    recentlyViewedCubit.add(recent);
  }
}

Future<List<RecentViewedBean>> getRecentViewedApi() async {
  var respRecentViewed = await MyDio().dio.get('$baseUrl/recent');
  var ret = <RecentViewedBean>[];
  for (var item in respRecentViewed.data['result'] ?? []) {
    ret.add(RecentViewedBean.fromJson(item));
  }
  return ret;
}
