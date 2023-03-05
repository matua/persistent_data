import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persistent_data/repo/hive_initializer.dart';

import '../model/category.dart';
import '../model/record.dart';

class CategoriesState with ChangeNotifier {
  final _categoriesBox = HiveRepo.categoriesBox;

  List<Category> getCategories() {
    return _categoriesBox.values.toList().isNotEmpty ? _categoriesBox.values.toList() : List.empty();
  }

  void addCategory(Category category) {
    if (getCategories().contains(category)) {
      throw Exception("Category is already in the database. Only unique record is allowed.");
    }
    _categoriesBox.put(category.id, category);
    notifyListeners();
  }
}
