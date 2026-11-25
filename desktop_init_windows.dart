import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Windows: SQLite through FFI, and the database lives in the user's private app-data folder.
Future<void> initDesktop() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  final dir = await getApplicationSupportDirectory();
  await Directory(dir.path).create(recursive: true);
  await databaseFactory.setDatabasesPath(dir.path);
}
