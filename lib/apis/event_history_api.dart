import '../beans/event_history_bean.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<EventHistoryBean?> getEventHistoryApi(String historyId) async {
  try {
    var response =
        await BasicDio().dio.get('$baseUrl/event_history/$historyId');
    return EventHistoryResp.fromJson(response.data).result;
  } catch (e) {
    return null;
  }
}
