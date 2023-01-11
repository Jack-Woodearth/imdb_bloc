import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imdb_bloc/apis/apis.dart';
import 'package:imdb_bloc/apis/basic_info.dart';
import 'package:imdb_bloc/apis/rsa.dart';
import 'package:imdb_bloc/apis/user_fav_photos_api.dart';
import 'package:imdb_bloc/apis/user_lists.dart';
import 'package:imdb_bloc/apis/watchlist_api.dart';
import 'package:imdb_bloc/beans/new_list_result_resp.dart';
import 'package:imdb_bloc/beans/watchlis_or_favpeople.dart';
import 'package:imdb_bloc/constants/config_constants.dart';
import 'package:imdb_bloc/cubit/user_recently_viewed_cubit.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_galleries_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_fav_photos_cubit.dart';
import 'package:imdb_bloc/cubit/user_rated_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/singletons/user.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/dio/dio.dart';
import 'package:imdb_bloc/utils/isolates/common_woker_isolate.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'apis/user_fav_galleries.dart';
import 'beans/MovieBeanWithUserWatchListTime.dart';
import 'singletons/app_doc_path.dart';

Future<void> globalInit() async {
  sqfliteFfiInit();
  await AppDocPath().initialize();
  // await CommonWorkerIsolate.init();
  await getPubKeyApi();
}

Future<void> initWithContext(BuildContext context) async {
  await initUser(context);

  initUserFavGalleries(context);
  initUserFavGalleries(context);
  initUserRated(context);
  initWatchListAndFavPeople(context);
  initRecent(context);
  initUserFavPhotos(context);
  getUserLists(context);
  dp('initWithContext finished');
}

Future<void> initUserFavGalleries(BuildContext context) async {
  var read = context.read<UserFavGalleriesCubit>();
  if (read.state.isNotEmpty) {
    return;
  }
  var gids = await getUserFavGalleriesApi();
  read.setGids(gids);
}

Future<void> initUserRated(BuildContext context) async {
  var read = context.read<UserRatedCubit>();
  if (read.state.titles.isNotEmpty) {
    return;
  }
  var titles = await getUserRatedTitlesApi();
  read.set(titles);
}

Future<void> initUser(BuildContext context) async {
  var read = context.read<UserCubit>();
  if (read.state.token != '') {
    return;
  }
  var sp = await SharedPreferences.getInstance();

  var userStr = sp.getString(userObjKey);
  if (!isBlank(userStr)) {
    user = User.fromJson(jsonDecode(userStr!));
    read.setUser(user);
  }
  dp('user inited');
}

Future<void> initWatchListAndFavPeople(BuildContext context) async {
  final userWatchListCubit = context.read<UserWatchListCubit>();
  final userFavPeopleCubit = context.read<UserFavPeopleCubit>();
  if (userWatchListCubit.state.movies.isNotEmpty ||
      userFavPeopleCubit.state.people.isNotEmpty) {
    return;
  }
  var response = await getWatchListOrFavPeople();
  // print(response.data);
  // final movies = <MovieBean>[];
  final movieIds = <String>[];
  final peopleIds = <String>[];
  final map = <String, WatchListOrFavPeopleBean>{};
  if (reqSuccess(response)) {
    for (var element in response.data['result'] ?? []) {
      final bean = WatchListOrFavPeopleBean.fromJson(element);
      map[bean.mid!] = bean;
      if (bean.mid!.startsWith('tt')) {
        movieIds.add(bean.mid!);
      } else if (bean.mid!.startsWith('nm')) {
        peopleIds.add(bean.mid!);
      }
    }
    getNewListMoviesApi(mids: movieIds).then((value) =>
        userWatchListCubit.setState(UserWatchListState(
            movies: value?.movies
                    ?.map((e) => e == null
                        ? null
                        : MovieBeanWithUserWatchListTime(
                            movieBean: e,
                            userWatchListTime: DateTime.tryParse(
                                    map[e.id]?.createTime ?? '') ??
                                DateTime.now()))
                    .where((element) => element != null)
                    .toList()
                    .cast<MovieBeanWithUserWatchListTime>() ??
                [])));

    getBasicInfoApi(peopleIds).then((value) => userFavPeopleCubit.setState(
        UserFavPeopleState(
            people: value
                .map((e) => PersonBeanWithUserWatchListTime(
                    personBean: e,
                    userWatchListTime:
                        DateTime.tryParse(map[e.id]?.createTime ?? '') ??
                            DateTime.now()))
                .toList())));
  }
}

Future<void> initRecent(BuildContext context) async {
  var cubit = context.read<UserRecentlyViewedCubit>();
  if (cubit.state.recentViewedBeans.isNotEmpty) {
    return;
  }
  var list = await getRecentViewedApi();
  list.sort();
  cubit.set(list);
}

Future<void> initUserFavPhotos(BuildContext context) async {
  var cubit = context.read<UserFavPhotosCubit>();
  if (cubit.state.photos.isNotEmpty) {
    return;
  }
  var list = await listUserFavPhotoApi();

  cubit.set(list);
}
