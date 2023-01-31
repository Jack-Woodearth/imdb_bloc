import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<Captcha?> getCaptchaApi() async {
  try {
    var response = await BasicDio().dio.get('$userUrl/captcha');
    if (response.statusCode == 429) {
      return null;
    }
    var data = response.data['result'];
    return Captcha(captcha: data['captcha'], id: data['captcha_id']);
  } catch (e) {
    return null;
  }
}

class Captcha {
  String id;
  String captcha;
  Captcha({required this.captcha, required this.id});
}
