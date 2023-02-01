import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<NameSearchResult> nameSearch(String name, {int page = 1}) async {
  var response = await BasicDio().dio.get('$baseUrl/search/people',
      queryParameters: {'name': name, 'page': page});
  if (response.data['result'] == null) {
    return NameSearchResult(count: 0, ids: []);
  }
  // var count = response.data['result'].last;
  // if (count is int) {
  //   response.data['result'].remove(count);
  // } else {
  //   count = response.data['result'].length;
  // }
  var data = response.data['result'];
  return NameSearchResult(
      count: data['count'], ids: data['ids'].cast<String>() ?? []);
}

class NameSearchResult {
  List<String> ids;
  int count;
  NameSearchResult({required this.count, required this.ids});
}
