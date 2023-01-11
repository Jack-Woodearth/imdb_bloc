import 'dart:math';

import 'package:imdb_bloc/singletons/user.dart';
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';

import '../constants/config_constants.dart';
import '../cubit/favlist_count_cubit.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';
import 'user_lists.dart';

Future<List<String>> getFavListsCovers() async {
  var lists = await getFavListsApi();
  var favListsCovers =
      await getListsCovers(listUrls: lists.sublist(0, min(3, lists.length)));
  return favListsCovers;
}

Future getFavListsCount(FavListCountCubit cubit) async {
  cubit.set(await getFavListCountApi() ?? 0);
}

Future<int?> getFavListCountApi() async {
  dp('getFavListCountApi');
  var uid = user.uid;
  if (uid == '') {
    return null;
  }
  try {
    var response = await MyDio().dio.get('$baseUrl/favlist/$uid?count=1');
    var data = response.data['result'];

    return data as int;
  } catch (e) {
    return null;
  }
}

Future<List<String>> getFavListsApi() async {
  var uid2 = user.uid;
  // print('uid=$uid2');
  if (uid2 == '') {
    return [];
  }
  try {
    var response = await MyDio().dio.get('$baseUrl/favlist/$uid2');
    var list = response.data['result']
        .map((e) => e['list_url'])
        .toList()
        .cast<String>();
    return list;
  } catch (e) {
    return [];
  }
}

Future<bool> deleteFavListApi(String listUrl) async {
  var uid2 = user.uid;
  if (uid2 == '') {
    return false;
  }
  try {
    var response = await MyDio().dio.delete('$baseUrl/favlist/$uid2',
        queryParameters: {'list_url': listUrl});
    return reqSuccess(response);
  } catch (e) {
    return false;
  }
}

Future<bool> addFavListApi(String listUrl) async {
  var uid2 = user.uid;
  if (isBlank(uid2)) {
    return false;
  }
  try {
    var response = await MyDio()
        .dio
        .post('$baseUrl/favlist/$uid2', queryParameters: {'list_url': listUrl});
    var reqSuccess2 = reqSuccess(response);
    if (!reqSuccess2) {
      print(response.data);
    }
    return reqSuccess2;
  } catch (e) {
    return false;
  }
}

Future<bool> isFavListApi(String listUrl) async {
  var uid2 = user.uid;
  if (uid2 == '') {
    return false;
  }
  try {
    var response = await MyDio()
        .dio
        .get('$baseUrl/favlist/$uid2', queryParameters: {'list_url': listUrl});
    return (response.data['result'] != null);
  } catch (e) {
    return false;
  }
}
