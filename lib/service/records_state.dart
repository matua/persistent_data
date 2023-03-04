import 'package:flutter/material.dart';
import 'package:persistent_data/repo/hive_initializer.dart';

import '../model/category.dart';
import '../model/record.dart';

class RecordsState with ChangeNotifier {
  final _recordsBox = HiveRepo.recordsBox;

  List<Record> getAllRecords() {
    return _recordsBox.values.toList().isNotEmpty ? _recordsBox.values.toList() : List.empty();
  }

  List<Record> getRecordsByCategory(Category category) {
    return _recordsBox.values.where((record) => record.category.id == category.id).toList();
  }

  Record? getRecordById(int id) {
    return _recordsBox.get(id);
  }

  void addRecord(
    int id,
    String name,
    String description,
    Category category,
  ) {
    if (getAllRecords().any((record) => record.name == name)) {
      throw Exception("Record is already in the database. Only unique record is allowed.");
    }
    final newRecord = Record(
      id: id,
      category: category,
      name: name,
      description: description,
    );
    _recordsBox.put(newRecord.id, newRecord);
    notifyListeners();
  }
}
