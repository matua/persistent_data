import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/record.dart';
import '../service/records_state.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late Color _backgroundColor;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _backgroundColor = _getRandomColor();
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        color: _backgroundColor,
        child: Consumer<RecordsState>(
          builder: (context, recordsState, child) {
            Record? record = recordsState.getRecordById(widget.id);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${record?.name}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${record?.description}", style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
