import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/category.dart';
import '../model/record.dart';

class HiveRepo {
  static Box<Record>? _recordsBox;
  static Box<Category>? _categoriesBox;

  static init() async {
    print('Initializing Hive...');

    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(RecordAdapter());
    Hive.registerAdapter(CategoryAdapter());
    _recordsBox = await Hive.openBox<Record>('recordsBox');
    _categoriesBox = await Hive.openBox<Category>('categoriesBox');
  }

  static Box<Record> get recordsBox => _recordsBox!;

  static Box<Category> get categoriesBox => _categoriesBox!;
}
