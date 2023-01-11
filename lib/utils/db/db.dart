import 'dart:io';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../constants/db_constants.dart';

Future<Database> getDb() async {
  var databaseFactory = databaseFactoryFfi;
  // var databasesPath = await getDatabasesPath();
  Directory databasesPath = await getApplicationDocumentsDirectory();
  String path = p.join(databasesPath.path, 'web_cache.db');
  // open the database
  Database database = await databaseFactory.openDatabase(path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE web_cache (url TEXT PRIMARY KEY, body TEXT)');
        },
      ));
  database.execute(
      'CREATE TABLE IF NOT EXISTS $jsonTable ($jsonTablePK TEXT PRIMARY KEY, $jsonTableJson TEXT)');
  database.execute(
      'CREATE TABLE IF NOT EXISTS $jsonTablePersonBasicInfo ($jsonTablePK TEXT PRIMARY KEY, $jsonTableJson TEXT)');
  database.execute(
      'CREATE TABLE IF NOT EXISTS $jsonTablePosterBasicInfo ($jsonTablePK TEXT PRIMARY KEY, $jsonTableJson TEXT)');
  database.execute(
      'CREATE TABLE IF NOT EXISTS $cacheStringTable (key TEXT PRIMARY KEY, content TEXT)');
  database.execute(
      'CREATE TABLE IF NOT EXISTS $cacheListStringTable (key TEXT PRIMARY KEY, content TEXT)');
  return database;
}
