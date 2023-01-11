import '../beans/advanced_name_search_resp.dart';
import '../beans/people_suggest_resp.dart';
import '../beans/search_suggest_bean.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';
import '../utils/string/string_utils.dart';

Future<List<SearchMovieSuggestBean>?> searchMovieSuggestApi(
  String title,
) async {
  if (isBlank(title)) {
    return null;
  }
  var t1 = DateTime.now();
  print(' searchMovieSuggestApi $title began');
  try {
    var response = await BasicDio()
        .dio
        .get(baseUrl + '/suggest/movies', queryParameters: {'title': title});
    var t2 = DateTime.now();
    print(
        ('searchMovieSuggestApi $title  costs ${t2.millisecondsSinceEpoch - t1.millisecondsSinceEpoch}ms'));
    return SearchSuggestResp.fromJson(response.data).result ?? [];
  } catch (e) {
    return null;
  }
}

Future<List<PersonSuggestBean>?> suggestPeopleApi(String name) async {
  if (isBlank(name)) {
    return null;
  }
  try {
    var response = await BasicDio()
        .dio
        .get(baseUrl + '/suggest/people', queryParameters: {'name': name});
    return PeopleSuggestResp.fromJson(response.data).result ?? [];
  } catch (e) {
    return null;
  }
}

Future<AdvancedNameSearchResult?> advancedNameSearchApi(
    Map<String, List<String>> params,
    {String nextUrl = ''}) async {
  if (!isBlank(nextUrl)) {
    try {
      var response = await BasicDio().dio.get(
          baseUrl + '/parse_imdb_people_search_result_by_url',
          queryParameters: {'url': nextUrl});
      return AdvancedNameSearchResp.fromJson(response.data).result;
    } catch (e) {
      return null;
    }
  }
  var paramsTrue = params
      .map((key, value) => MapEntry(key == 'Title' ? 'name' : key, value));
  paramsTrue.removeWhere((key, value) => value.isEmpty);

  try {
    var response = await BasicDio().dio.get(baseUrl + '/search/people/advanced',
        queryParameters:
            paramsTrue.map((key, value) => MapEntry(key, value.join(','))));
    return AdvancedNameSearchResp.fromJson(response.data).result;
  } catch (e) {
    return null;
  }
}
