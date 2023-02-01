import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/list_repr_images_api.dart';
import '../../apis/user_lists.dart';
import '../../beans/list_resp.dart';
import '../../utils/sp/sp_utils.dart';

class WhatsOnTVCardData {
  ListResult listResult;
  List<String> pics;
  WhatsOnTVCardData({required this.listResult, required this.pics});
}

Future<WhatsOnTVCardData?> getWhatsOnTVCardData(String id) async {
  var url = '/list/$id';

  ListResult? _listResult;
  List<String> _pics = [];
  var listResp =
      await SpCache.wrapped(ListResp.fromJson, getListDetailApi, [url]);
  _listResult = listResp.result;

  if (_listResult == null) {
    return null;
  }

  return WhatsOnTVCardData(
      listResult: _listResult,
      pics: await SpListCache.wrapped(getListCoverPics, [_listResult, url]));
}

Future<List<String>> getListCoverPics(
    ListResult listResultFromServer, String url) async {
  List<String> _pics = [];
  if (listResultFromServer.isPictureList == true) {
    _pics = listResultFromServer.pictures
            ?.map((e) => e.pic!)
            .toList()
            .sublist(0, 3) ??
        [];
  } else {
    _pics = await getListReprImagesApi(url);
  }
  return _pics;
}

Future<List<WhatsOnTVCardData?>> batchGetWhatsOnTVCardData(
    List<String> ids) async {
  var futures = await Future.wait(ids.map((id) => getWhatsOnTVCardData(id)));
  return futures;
}
