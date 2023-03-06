// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/dto/safe_user.dart';
import 'user_dao.dart';

part 'db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [SafeUser])
abstract class AppDatabase extends FloorDatabase {
  SafeUserDao get userDao;
}
