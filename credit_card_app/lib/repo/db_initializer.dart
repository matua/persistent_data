import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

class DBInitializer {
  static Future<AppDatabase> init() async {
    // await deleteDatabase('card_app.db');
    // const storage = FlutterSecureStorage();
    // await storage.deleteAll();
    return Future.sync(() => $FloorAppDatabase.databaseBuilder('card_app.db').build());
  }
}
