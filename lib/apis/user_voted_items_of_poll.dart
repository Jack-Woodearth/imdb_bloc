import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<int> getUserVotedItemsOfPollApi(String pollId) async {
  var path = '$baseUrl/poll/$pollId/vote';
  var response = await MyDio().dio.get(path);
  var votedItemId = response.data['result'] as int;
  return votedItemId;
}

Future<bool> votePollItem(String pollId, int itemId) async {
  var path = '$baseUrl/poll/$pollId/vote';
  var response = await MyDio().dio.post(path, data: {'item_id': itemId});
  return response.data['code'] == 200;
}
