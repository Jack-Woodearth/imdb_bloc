import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/apis/user_info.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/cubit/user_list_screen_filter_cubit.dart';

import '../beans/list_resp.dart';
import '../constants/config_constants.dart';
import '../singletons/user.dart';
import '../utils/dio/mydio.dart';
import '../utils/list_utils.dart';
import '../utils/string/string_utils.dart';
import '../widget_methods/widget_methods.dart';
import 'list_repr_images_api.dart';

Future<List<String>> getUserListsApi(int uid) async {
  try {
    var url = '$baseUrl/list/$uid';
    var response = await MyDio().dio.get(url);
    return ((response.data['result'] ?? []) as List).cast<String>();
  } catch (e) {
    return [];
  }
}

Future<ListResult?> addUserListApi(
  String listDescription,
  String listName,
  bool isPublic,
  bool isPeopleList,
) async {
  var path = '$baseUrl/list';
  var data2 = {
    'author_name': user.username,
    'list_description': listDescription,
    'list_name': listName,
    'is_public': isPublic,
    'is_people_list': isPeopleList
  };
  print(data2);
  var response = await MyDio().dio.post(path, data: data2);
  if (response.statusCode == 200 && response.data['code'] == 200) {
    return ListResult.fromJson(response.data['result']);
  }
  return null;
}

Future<void> updateUserLists() async {
  //todo
  // Get.find<UserListScreenFilterController>().listUrls.clear();
  // await getUserLists();
}

Future<ListResp> getListDetailApi(
  String? url, {
  bool requireDetails = false,
  bool isPeopleList = false,
  int page = 1,
  bool requireIds = true,
}) async {
  if (isBlank(url)) {
    return ListResp();
  }
  var queryParameters = {
    'linkTargetUrl': url,
    'require_details': requireDetails,
    'is_people_list': isPeopleList,
    'page': page,
    'require_ids': requireIds
  };

  // var sharedPreferences = Get.find<SharedPreferences>();
  // final key = queryParameters.toString();
  // var string = sharedPreferences.getString(key);
  // if (string != null) {
  //   return ListResp.fromJson(jsonDecode(string));
  // }
  var resp =
      await MyDio().dio.get('$baseUrl/list', queryParameters: queryParameters);
  // print(resp.data);
  var ret = ListResp.fromJson(resp.data);
  // sharedPreferences.setString(key, jsonEncode(ret.toJson()));
  return ret;
}

Future<String?> getListCoverApi(String? listUrl) async {
  // final key = 'getListCoverApi-$listUrl';
  // var sp = Get.find<SharedPreferences>();
  // var cover = sp.getString(key);
  // if (cover != null) {
  //   return cover;
  // }
  if (isBlank(listUrl)) {
    return null;
  }
  var path = '$baseUrl/list/covers?linkTargetUrl=$listUrl';
  var response = await MyDio().dio.get(path);
  try {
    var coverFromServer = response.data['result'];
    // sp.setString(key, coverFromServer);
    return coverFromServer;
  } catch (e) {
    return null;
  }
}

Future<bool> addOrRemoveSubjectsToListApi(String? listUrl, List<String> ids,
    {bool isDelete = false}) async {
  if (isBlank(listUrl)) {
    return false;
  }
  var path = '$baseUrl/list';
  var response = await MyDio().dio.put(path,
      data: {'list_url': listUrl, 'ids': ids, 'is_delete': isDelete});
  // print(response.data);
  return response.data['code'] == 200;
}

Future<bool> deleteListApi(String? listUrl) async {
  if (isBlank(listUrl)) {
    return false;
  }
  var path = '$baseUrl/list';
  var response = await MyDio().dio.delete(path, data: {'list_url': listUrl});
  // print(response.data);
  return response.data['code'] == 200;
}

Future<void> deleteIdFromList(
  String id,
  String? listUrl,
  BuildContext context,
  VoidCallback afterDelete, {
  required String authorId,
}) async {
  // print('$UserListScreen');
  if (authorId == user.uid) {
    showConfirmDialog(context, 'Delete this from list?', () async {
      EasyLoading.show();

      var bool = await addOrRemoveSubjectsToListApi(listUrl ?? '', [id],
          isDelete: true);
      EasyLoading.dismiss();

      if (bool) {
        EasyLoading.showSuccess('deleted from list');
      } else {
        EasyLoading.showSuccess('delete failed');
      }
      updateUserLists();
      //todo
      // Get.back();
      afterDelete();
    });
  }
}

Future<List<String>> getListCoverPics(
    ListResult listResultFromServer, String url) async {
  List<String> pics = [];
  if (listResultFromServer.isPictureList == true) {
    pics = listResultFromServer.pictures
            ?.map((e) => e.pic!)
            .toList()
            .sublist(0, 3) ??
        [];
  } else {
    pics = await getListReprImagesApi(url);
  }
  return pics;
}

Future<List<String>> getListsCovers(
    {List<ListResult> lists = const [],
    List<String> listUrls = const []}) async {
  // var lists = Get.find<UserListScreenFilterController>().userLists;
  // print('getListsCovers $lists');
  var futures = <Future<List<String>>>[];
  if (lists.isNotEmpty) {
    for (var list in lists) {
      if (!isBlank(list.listUrl)) {
        futures.add(getListCoverPics(list, list.listUrl ?? ''));
      }
    }
  } else if (listUrls.isNotEmpty) {
    for (var listUrl in listUrls) {
      futures.add(getListReprImagesApi(listUrl));
    }
  }

  var futuresRet = (await Future.wait(futures))
      .where((element) => element.isNotEmpty)
      .toList();
  return List<String>.generate(
      futuresRet.length, (index) => futuresRet[index].first);
}

Future<List<ListResult>> batchGetListsDetails(List<String> urls) async {
  var response = await MyDio().dio.get('$baseUrl/list/batch',
      queryParameters: {'list_urls': urls.join('-')});
  var ret = <ListResult>[];
  for (var element in response.data['result'] ?? []) {
    try {
      ret.add(ListResult.fromJson(element));
    } catch (e) {
      // TODO
    }
  }
  return ret;
}

Future<List<String>> getListUrlsContainingSubjectId(String mid) async {
  try {
    var response = await MyDio().dio.get('$baseUrl/list/${user.uid}/contains',
        queryParameters: {'subject_id': mid});
    return ((response.data['result'] ?? []) as List).cast<String>();
  } catch (e) {
    return [];
  }
}

Future<void> getUserLists(BuildContext context) async {
  var cubit = context.read<UserListCubit>();
  if (cubit.state.listUrls.isNotEmpty) {
    return;
  }
  if (!context.read<UserCubit>().state.isLogin) {
    print('!context.read<UserCubit>().state.isLogin');
    return;
  }
  var uid = await getUid();

  if (uid == null) {
    print('uid == null');
    return;
  }
  var list = await getUserListsApi(uid);
  print('da54sd564a56d4a56d');
  print(list.length);
  cubit.setState(UserListScreenFilterNormal(
      listUrls: list,
      pageIndex: 0,
      hasNextPage: true,
      pages: splitList(list, 7),
      currentFilters: const {},
      userLists: const []));
  return;
}
