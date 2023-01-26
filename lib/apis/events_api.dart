import '../beans/gallery.dart';
import '../beans/list_resp.dart';
import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';

Future<List<String>> eventsNames() async {
  var response = await MyDio().dio.get('$baseUrl/events/all');
  if (reqSuccess(response)) {
    return (response.data['result'] ?? []).cast<String>();
  }

  return [];
}

Future<EventDetail?> eventDetailApi(String eventName) async {
  var response = await MyDio().dio.get('$baseUrl/events/$eventName');
  if (reqSuccess(response)) {
    var data = response.data;
    var res = data['result'];
    EventDetail eventDetail = EventDetail(galleries: [], lists: []);
    for (var ga in res['galleries']) {
      var tmp = <ImdbGallery>[];

      for (var g in ga) {
        tmp.add(ImdbGallery.fromJson(g.cast<String, dynamic>()));
      }
      eventDetail.galleries.add(tmp);
    }
    for (var li in res['lists']) {
      eventDetail.lists.add(ListResult.fromJson(li.cast<String, dynamic>()));
    }
    return eventDetail;
  }
  return null;
}

class EventDetail {
  List<List<ImdbGallery>> galleries;
  List<ListResult> lists;

  EventDetail({required this.galleries, required this.lists});
}

Future<String?> getEventCoverApi(String eventName) async {
  var data = await MyDio().get('$baseUrl/events/$eventName/cover');
  return data['result'];
}
