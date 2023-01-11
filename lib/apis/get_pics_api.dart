import '../beans/user_fav_photos.dart';
import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';
import '../utils/string/string_utils.dart';

Future<List<PhotoWithSubjectId>> getPicsApi(String? subjectId,
    {int page = 1}) async {
  if (isBlank(subjectId)) {
    return [];
  }
  var response = await MyDio()
      .dio
      .get(baseUrl + '/pics/$subjectId', queryParameters: {'page': page});
  var ret = <PhotoWithSubjectId>[];
  if (reqSuccess(response) && response.data['result'] != null) {
    for (var element in response.data['result']) {
      var split = element.toString().split('*');
      String? href;
      if (split.length > 1) {
        href = split[1];
      }
      ret.add(PhotoWithSubjectId(
          photoUrl: split[0], imageViewerHref: href, subjectId: subjectId));
    }
  }
  return ret;
}

Future<int?> getPicsCountApi(String subjectId) async {
  if (isBlank(subjectId)) {
    return null;
  }
  var response = await MyDio().dio.get(baseUrl + '/pics/$subjectId/count');
  var data = response.data['result'];
  return data;
}
