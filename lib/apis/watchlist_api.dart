import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/basic_info.dart';
import 'package:imdb_bloc/beans/MovieBeanWithUserWatchListTime.dart';
import 'package:imdb_bloc/cubit/user_fav_people_cubit.dart';
import 'package:imdb_bloc/cubit/user_watch_list_cubit.dart';
import 'package:imdb_bloc/singletons/user.dart';

import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';
import '../widget_methods/widget_methods.dart';
import 'apis.dart';

Future<Response> updateWatchListOrFavPeople(
    String id, BuildContext context) async {
  if (!MID_OR_PID_PATTERN_EXACT.hasMatch(id)) {
    return Response(
        statusCode: 500, requestOptions: RequestOptions(path: 'path'));
  }
  final UserWatchListCubit userWatchListCubit =
      context.read<UserWatchListCubit>();
  final UserFavPeopleCubit userFavPeopleCubit =
      context.read<UserFavPeopleCubit>();
  var resp = await MyDio().dio.post('$baseUrl/watchlist?id=$id',
      options: Options(headers: {'Authorization': user.token}));
  if (reqSuccess(resp)) {
    // final watchlist = Get.find<User>().watchList;
    if (resp.data['result'] == 'remove success') {
      // WatchListOrFavPeopleBeanMap().map.remove(id);
      if (id.startsWith('tt')) {
        userWatchListCubit.remove(id);
      } else if (id.startsWith('nm')) {
        userFavPeopleCubit.remove(id);
      }
    } else {
      if (id.startsWith('tt')) {
        // var result2 = (await getMovieDetailsApi([id]))?.result;
        var result2 = await getNewListMoviesApi(mids: [id]);
        if (result2?.movies?.isNotEmpty == true) {
          var movie = result2!.movies!.first;
          if (movie != null) {
            userWatchListCubit.addMovie(MovieBeanWithUserWatchListTime(
                movieBean: movie, userWatchListTime: DateTime.now()));
          }
        }
      } else if (id.startsWith('nm')) {
        getBasicInfoApi([id]).then((value) {
          if (value.isNotEmpty == true) {
            var person = value.first;
            userFavPeopleCubit.add(PersonBeanWithUserWatchListTime(
                personBean: person, userWatchListTime: DateTime.now()));
          }
        });
      }
    }
  }
  return resp;
}

Future<Response> getWatchListOrFavPeople() async {
  return MyDio().dio.get('$baseUrl/watchlist',
      options: Options(headers: {'Authorization': user.token}));
}

Options getAuth() {
  return Options(headers: {'Authorization': user.token});
}

Future<void> handleUpdateWatchListOrFavPeople(
    String id, BuildContext context) async {
  // 移出
  if (isFavPeopleOrInWatchList(id, context)) {
    showConfirmDialog(context,
        'Remove from ${id.startsWith('tt') ? 'watch list' : 'favorite people'}?',
        () {
      actuallyUpdateWatchListOrFavPeople(id, context);
      GoRouter.of(context).pop();
    });
  } else {
    //加入
    await actuallyUpdateWatchListOrFavPeople(id, context);
  }
}

Future<void> actuallyUpdateWatchListOrFavPeople(
    String id, BuildContext context) async {
  EasyLoading.show();
  try {
    var resp = await updateWatchListOrFavPeople(id, context);
    // EasyLoading.dismiss();

    // print(resp.data);
    if (reqSuccess(resp)) {
      // EasyLoading.showSuccess(resp.data['result'].toString());

      EasyLoading.showSuccess('Success');
    } else {
      // EasyLoading.showError('${resp.statusCode},${resp.data}');
    }
  } finally {
    EasyLoading.dismiss();
  }
}
