import 'package:dio/dio.dart';

import '../beans/poll_resp.dart';
import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';

Future<PollResult?> getPollApi(String pollId) async {
  var resp = await Dio().get(baseUrl + '/poll/$pollId');
  if (reqSuccess(resp)) {
    return PollResp.fromJson(resp.data).result;
  }
  return null;
}
