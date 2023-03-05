import 'db.dart';

class DBInitializer {
  static Future<AppDatabase> init() {
    return Future.sync(() => $FloorAppDatabase.databaseBuilder('app_database.db').build());
  }
}
