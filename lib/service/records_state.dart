import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persistent_data/repo/hive_initializer.dart';

import '../model/record.dart';

class RecordsState with ChangeNotifier {
  final _recordsBox = HiveRepo.recordsBox;

  List<Record> getRecords() {
    return _recordsBox.values.toList().isNotEmpty ? _recordsBox.values.toList() : List.empty();
  }

  void addRecord(Record record) {
    if (getRecords().contains(record)) {
      throw Exception("Record is already in the database. Only unique record is allowed.");
    }
    _recordsBox.put(record.id, record);
    notifyListeners();
  }
}
