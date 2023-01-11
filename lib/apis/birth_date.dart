import 'package:dio/dio.dart';

import '../constants/config_constants.dart';
import '../utils/dio/mydio.dart';
import '../utils/sp/sp_utils.dart';

Future<BirthDatePeopleResp> getPeopleFromBirthDateApi(String date,
    {int start = 1}) async {
  // var key = 'getPeopleFromBirthDateApi $date $start';
  // var cache = SpCache.get(key, BirthDatePeopleResp.fromResponseData);
  // if (cache != null) {
  //   return cache;
  // }
  // BirthDatePeopleResp parseBirthPeople2 = await getPeopleFromBirthDateApiNoCache(date, start);
  // SpCache.set(key, parseBirthPeople2);
  // return parseBirthPeople2;
  return SpCache.wrapped(BirthDatePeopleResp.fromResponseData,
      getPeopleFromBirthDateApiNoCache, [date, start]);
}

Future<BirthDatePeopleResp> getPeopleFromBirthDateApiNoCache(
    String date, int start) async {
  var response =
      await MyDio().dio.get('$baseUrl/birth_date/$date?start=$start');
  var parseBirthPeople2 = BirthDatePeopleResp.fromResponseData(response.data);
  return parseBirthPeople2;
}

Future<BirthDatePeopleResp> getPeopleFromBirthYearApi(String year,
    {int start = 1}) async {
  var response =
      await MyDio().dio.get('$baseUrl/birth_year/$year?start=$start');
  return BirthDatePeopleResp.fromResponseData(response.data);
}

Future<BirthDatePeopleResp> getPeopleFromBirthPlaceApi(String place,
    {int start = 1}) async {
  var response =
      await MyDio().dio.get('$baseUrl/birth_place/$place?start=$start');

  return BirthDatePeopleResp.fromResponseData(response.data);
}

class BirthDatePeopleResp {
  final List<String> ids;
  final int count;
  BirthDatePeopleResp({
    required this.ids,
    required this.count,
  });
  Map<String, dynamic> toJson() {
    return {
      'code': 200,
      'msg': '',
      'result': [ids, count]
    };
  }

  static BirthDatePeopleResp fromResponseData(dynamic data) {
    try {
      // var data = response.data['result'];
      print(data);
      data = data['result'];
      List<String> ids = [];
      for (var element in data[0]) {
        ids.add(element.toString());
      }
      return BirthDatePeopleResp(ids: ids, count: data[1]);
    } catch (e) {
      return BirthDatePeopleResp(ids: [], count: 0);
    }
  }
}
