import '../beans/person_info_of_person_list_resp.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<List<PersonInfoOfPersonList?>> getPersonInfoOfPersonListApi(
    List<String> pids) async {
  if (pids.isEmpty) {
    return [];
  }
  var path = '$baseUrl/persons/info_of_person_list/${pids.join("-")}';
  var map = (await MyDio().dio.get(path)).data;
  return PersonInfoOfPersonListResp.fromJson(map).result ?? [];
}
