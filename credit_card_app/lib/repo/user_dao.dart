import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/user.dart';

part 'user_dao.g.dart';

@Database(version: 1, entities: [User])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<User>> getAllUsers();

  @insert
  Future<void> addUser(User user);

  @delete
  Future<void> deleteUser(User user);

  @update
  Future<void> updateUser(User user);

  @Query('SELECT * FROM users WHERE id = :id')
  Future<User?> getUserById(int id);

  @Query('SELECT * FROM users WHERE first_name = :firstName AND last_name = :lastName')
  Future<User?> getUserByFullName(String firstName, String lastName);
}
