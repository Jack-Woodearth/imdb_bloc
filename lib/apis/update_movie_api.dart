import 'dart:convert';

import 'package:imdb_bloc/utils/db/db.dart';

import '../beans/details.dart';
import '../constants/config_constants.dart';
import '../constants/db_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';

Future<MovieBean?> updateMovieApi(String mid) async {
  var response = await MyDio().dio.get(baseUrl + '/update/$mid');
  if (reqSuccess(response)) {
    var ret = MovieBean.fromJson(response.data['result']);

    var db = await getDb();
    // var list = await db.query(jsonTable, where: 'id=?', whereArgs: [mid]);
    // if (list.isNotEmpty) {
    //   var dbM =
    //       MovieBean.fromJson(jsonDecode(list.first[jsonTableJson] as String));
    //   dbM.rate = ret.rate;
    //   db.update(jsonTable, {jsonTableJson: jsonEncode(dbM.toJson())},
    //       where: 'id=?', whereArgs: [mid]);

    // }
    db.delete(jsonTable, where: 'id=?', whereArgs: [mid]);
    db.insert(
        jsonTable, {'id': ret.id, jsonTableJson: jsonEncode(ret.toJson())});
    db.delete(jsonTablePosterBasicInfo, where: 'id=?', whereArgs: [mid]);

    return ret;
  }

  return null;
}
