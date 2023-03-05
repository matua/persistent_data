import 'package:flutter/material.dart';

import 'views/cards_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Drift Package Demo',
      home: CardsPage(),
    );
  }
}
