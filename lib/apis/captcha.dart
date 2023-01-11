import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<Captcha> getCaptchaApi() async {
  var response = await BasicDio().dio.get(userUrl + '/captcha');
  var data = response.data['result'];
  return Captcha(captcha: data['captcha'], id: data['captcha_id']);
}

class Captcha {
  String id;
  String captcha;
  Captcha({required this.captcha, required this.id});
}
