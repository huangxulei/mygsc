import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SQLHelper {
  static Future<void> initialDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var databasesPath = await databaseFactory.getDatabasesPath();
    var path = join(databasesPath, "poetry.db");
    var exists = await databaseFactory.databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load('assets/poetry.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
  }

  static Future<sql.Database> db() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'poetry.db');
    return await sql.openDatabase(path);
  }
}
