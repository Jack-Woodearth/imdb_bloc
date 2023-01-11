import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<List<String>> whatsOnTvApi() async {
  try {
    var response = await MyDio().dio.get(baseUrl + '/whats_on_tv');
    return response.data['result'].cast<String>();
  } catch (e) {
    return [];
  }
}
