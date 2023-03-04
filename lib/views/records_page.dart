import 'package:flutter/material.dart';
import 'package:persistent_data/model/category.dart';
import 'package:persistent_data/service/records_state.dart';
import 'package:provider/provider.dart';

import '../model/record.dart';
import 'record_page.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({Key? key, required this.category, required this.categoryIndex}) : super(key: key);
  final Category category;
  final int categoryIndex;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = _animationController
        .drive(ColorTween(begin: Colors.white, end: Colors.primaries[widget.categoryIndex % Colors.primaries.length]));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Record> records = context.watch<RecordsState>().getRecordsByCategory(widget.category);

    return Scaffold(
      appBar: AppBar(
        title: Text("Records in ${widget.category.name}"),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          color: _animation.value,
          child: records.isNotEmpty
              ? ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      records[index].name,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RecordPage(id: records[index].id),
                        ),
                      );
                    },
                  ),
                )
              : const Center(child: Text("No Records in this category")),
        ),
      ),
    );
  }
}
