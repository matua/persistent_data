import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persistent_data/model/category.dart';
import 'package:persistent_data/repo/hive_initializer.dart';
import 'package:persistent_data/service/records_state.dart';
import 'package:persistent_data/views/categories_page.dart';
import 'package:provider/provider.dart';

import 'service/categories_state.dart';

Future<void> main() async {
  await HiveRepo.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecordsState>(
          create: (_) => RecordsState(),
        ),
        ChangeNotifierProvider<CategoriesState>(
          create: (_) => CategoriesState(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hive Demo',
        home: CategoriesPage(),
      ),
    );
  }
}
