import 'package:flutter/material.dart';
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
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF000000,
            <int, Color>{
              50: Color(0xFF000000),
              100: Color(0xFF000000),
              200: Color(0xFF000000),
              300: Color(0xFF000000),
              400: Color(0xFF000000),
              500: Color(0xFF000000),
              600: Color(0xFF000000),
              700: Color(0xFF000000),
              800: Color(0xFF000000),
              900: Color(0xFF000000),
            },
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Hive Demo',
        home: const CategoriesPage(),
      ),
    );
  }
}
