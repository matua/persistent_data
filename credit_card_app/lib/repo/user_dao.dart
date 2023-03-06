import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/dto/safe_user.dart';

part 'user_dao.g.dart';

@Database(version: 1, entities: [SafeUser])
abstract class AppDatabase extends FloorDatabase {
  SafeUserDao get userDao;
}

@dao
abstract class SafeUserDao {
  @Query('SELECT * FROM safe_users')
  Future<List<SafeUser>> getAllUsers();

  @insert
  Future<void> addUser(SafeUser safeUser);

  @delete
  Future<void> deleteUser(SafeUser safeUser);

  @update
  Future<void> updateUser(SafeUser safeUser);

  @Query('DELETE FROM safe_users')
  Future<void> deleteAllUsers();
}
