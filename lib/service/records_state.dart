import 'package:flutter/material.dart';

import '../model/record.dart';

class RecordsState with ChangeNotifier {
  final List<Record> _records = ;

  List<Record> get records => _records;

}
