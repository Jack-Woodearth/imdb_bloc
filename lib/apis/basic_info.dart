import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:imdb_bloc/utils/db/db.dart';

import '../beans/poster_bean.dart';
import '../constants/config_constants.dart';
import '../constants/db_constants.dart';
import '../utils/dio/mydio.dart';

// final cache = <String, BasicInfo>{};
Future<List<BasicInfo>> getBasicInfoApi(List<String> ids) async {
  if (ids.isEmpty) {
    return [];
  }
  final idsBak = ids.toList();

  var db = await getDb();
  var local = await db.rawQuery(
      'select $jsonTablePK,$jsonTableJson from $jsonTablePosterBasicInfo where id in (${ids.map(
            (e) => '\'' + e + '\'',
          ).toList().join(',')})');
  var localRet = local.map((e) {
    var basicInfo = BasicInfo.fromJson(
        jsonDecode(e[jsonTableJson] as String) as Map<String, dynamic>);

    return basicInfo;
  }).toList();
  if (localRet.isNotEmpty) {
    // print('getBasicInfoApi hit local db');
  }
  // print('localRet=${localRet}');
  var idsLocal = local.map((e) => e[jsonTablePK]).toList();
  var idsWeb = ids.toSet().difference(idsLocal.toSet());

  var webRet = <BasicInfo>[];
  try {
    if (idsWeb.isNotEmpty) {
      // print('getBasicInfoApi hit web');

      var url = '$baseUrl/basicinfo/${idsWeb.join('-')}';
      var resp = await MyDio().dio.get(url);
      webRet = BasicInfoResp.fromJson(resp.data).result!;
      for (var item in webRet) {
        try {
          db.delete(jsonTablePosterBasicInfo,
              where: 'id=?', whereArgs: [item.id]);
          db.insert(jsonTablePosterBasicInfo,
              {jsonTablePK: item.id, jsonTableJson: jsonEncode(item.toJson())});
        } catch (e) {
          // TODO
          debugPrintStack();
        }
      }
    }
  } catch (e) {}
  var ret = <BasicInfo>[];
  localRet.addAll(webRet);
  // localRet.addAll(cacheRet);

  for (var id in idsBak) {
    for (var info in localRet) {
      if (id == info.id) {
        ret.add(info);
        continue;
      }
    }
  }

  // assert(ret.length == ids.length);
  return ret;
}
