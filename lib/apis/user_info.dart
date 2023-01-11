import 'package:imdb_bloc/singletons/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../beans/user_info.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';
import '../utils/string/string_utils.dart';

Future<UserInfo?> getUserInfoApi() async {
  var path = '$userUrl/ajax_get_userinfo';
  var response = await MyDio().dio.get(path);

  var user2 = UserinfoResp.fromJson(response.data).user;
  print(user2?.toJson());
  if (user2 != null && user2.id != null) {
    (await SharedPreferences.getInstance()).setInt('uid', user2.id!);
  }
  return user2;
}

Future<int?> getUid() async {
  var uid = user.uid;
  return int.tryParse(uid);
}

Future<bool> changePassword(String password, String newPassword) async {
  try {
    var response = await MyDio().dio.put('$userUrl/change_password', data: {
      'password': await encryptPwd(password),
      'new_password': await encryptPwd(newPassword)
    });
    return response.data['code'] == 200;
  } catch (e) {
    return false;
  }
}
