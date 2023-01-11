import 'package:shared_preferences/shared_preferences.dart';

import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<bool> googleSigninApi(String idToken) async {
  // var encryptIdToken = await encryptPwd(idToken);
  var path = '$userUrl/google_signin?id_token=$idToken';
  var response = await MyDio().dio.post(path);
  if (response.data['code'] == 200) {
    var token = response.data['result']['token'];
    var user = response.data['result']['user'];
    var sp = await SharedPreferences.getInstance();
    sp.setString(tokenKey, token);
    sp.setInt('uid', user['id']);
    sp.setString('username', user['username']);

    return true;
  }
  return false;
}
