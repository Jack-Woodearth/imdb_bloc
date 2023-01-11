import '../beans/cast_bean.dart';
import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';

Future<List<FullCreditPersonBean>> getFullCreditApi(String mid) async {
  try {
    var data = await MyDio().get('$baseUrl/fullcredit/$mid');
    final people = FullCreditResp.fromJson(data).result ?? [];
    return people;
  } catch (e) {
    return [];
  }
}
