import 'package:flutter/material.dart';

import '../model/user.dart';
import '../repo/db.dart';

class UserState with ChangeNotifier {
  final AppDatabase db;

  UserState(this.db);

  Future<List<User>> getAllUsers() async {
    return await db.userDao.getAllUsers();
  }

  void addUser(User user) async {
    db.userDao.addUser(user);
    notifyListeners();
  }

  void deleteUser(User user) {
    db.userDao.deleteUser(user);
    notifyListeners();
  }

  User updateUser(User user) {
    db.userDao.updateUser(user);
    notifyListeners();
    return user;
  }
}
