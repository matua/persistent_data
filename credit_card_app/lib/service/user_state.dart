import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/dto/converter.dart';
import '../model/dto/safe_user.dart';
import '../repo/db.dart';

class UserState with ChangeNotifier {
  final AppDatabase db;
  final _storage = const FlutterSecureStorage();

  UserState(this.db);

  Future<List<SafeUser>> getAllUsers() async {
    final users = await db.userDao.getAllUsers();
    for (var user in users) {
      String? card = await getBankCardByUser(user);
      UserConverter.safeUserAndCardNumberToUserConverter(user, card);
    }
    printAllBankCards();
    return users;
  }

  void addUser(SafeUser safeUser, String cardNumber) async {
    // Generate a new ID for the user
    final newUser = safeUser.copyWith(id: DateTime.now().microsecondsSinceEpoch);
    await db.userDao.addUser(newUser);

    // Save the bank card information in secure storage
    final userCardKey = '${newUser.id}_user_card_key';
    await _storage.write(key: userCardKey, value: cardNumber);

    List<SafeUser> users = [];
    try {
      users = await db.userDao.getAllUsers();
    } catch (e) {
      print(e.toString());
    }

    print('Added user with id ${newUser.id} to the database');
    print('All users in the database: $users');
    notifyListeners();
  }

  void deleteUser(SafeUser user) async {
    final userCardKey = '${user.id}_user_card_key';
    await _storage.delete(key: userCardKey);
    db.userDao.deleteUser(user);
    notifyListeners();
  }

  Future<SafeUser> updateUser(SafeUser user, String cardNumber) async {
    final userCardKey = '${user.id}_user_card_key';
    if (cardNumber.isNotEmpty) {
      await _storage.write(key: userCardKey, value: cardNumber);
    }
    final updatedUser = user.copyWith(
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      image: user.image,
    );
    await db.userDao.updateUser(updatedUser);
    print("User updated in database: $updatedUser");
    notifyListeners();
    return updatedUser;
  }

  Future<String> getBankCardByUser(SafeUser user) async {
    final userCardKey = '${user.id}_user_card_key';
    print('userCardKey: $userCardKey');
    final card = await _storage.read(key: userCardKey);
    print('card: $card');
    if (card != null && card.isNotEmpty) {
      // Format the card number with asterisks
      final last4Digits = card.substring(card.length - 4);
      final maskedNumber = '**** **** **** $last4Digits';
      print('Card number for user ${user.id}: $maskedNumber');
      return maskedNumber;
    } else {
      throw Exception('Card number not found or is empty');
    }
  }

  Future<List<String>> getAllBankCards() async {
    final allKeys = await _storage.readAll();
    final bankCardKeys = allKeys.keys.where((key) => key.endsWith('_user_card_key'));
    final bankCards = <String>[];
    for (final key in bankCardKeys) {
      final card = await _storage.read(key: key);
      if (card != null) {
        bankCards.add(card);
      }
    }
    return bankCards;
  }

  void printAllBankCards() async {
    print("PRINTING ALL BANK CARDS:");
    final allKeys = await _storage.readAll();
    final bankCardKeys = allKeys.keys.where((key) => key.endsWith('_user_card_key'));
    for (final key in bankCardKeys) {
      final card = await _storage.read(key: key);
      if (card != null) {
        print("Card number for key $key: $card");
      } else {
        print("No card number found for key $key");
      }
    }
  }

  void deleteBankCard(String userId) async {
    final userCardKey = '${userId}_user_card_key';
    await _storage.delete(key: userCardKey);
    notifyListeners();
  }

  Future<void> deleteAllUsers() async {
    await db.userDao.deleteAllUsers();
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> printAllData() async {
    print("PRINTING DATA");
    final allData = await _storage.readAll();
    print("Printing all data in secure storage:");
    allData.forEach((key, value) {
      print("SEC: $key: $value");
    });
  }

  int? findUserId(SafeUser user) {
    return user.id;
  }

  Future<bool> hasUsers() async {
    final users = await db.userDao.getAllUsers();
    return users.isNotEmpty;
  }
}
