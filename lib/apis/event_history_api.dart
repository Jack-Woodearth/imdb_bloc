import '../beans/event_history_bean.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<EventHistoryBean?> getEventHistoryApi(String? historyId,
    {String? eventId, int? year, int? number}) async {
  try {
    var response = await BasicDio().dio.get('$baseUrl/event_history/$historyId',
        queryParameters: {'eventId': eventId, 'year': year, 'number': number});
    // var t1 = DateTime.now();
    var result2 = EventHistoryResp.fromJson(response.data).result;
    // var t2 = DateTime.now();
    // print(
    //     'getEventHistoryApi fromJson time= ${t2.millisecondsSinceEpoch - t1.millisecondsSinceEpoch}ms');
    return result2;
  } catch (e) {
    print(e);
    return null;
  }
}
