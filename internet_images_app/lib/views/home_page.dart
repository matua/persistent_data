import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _urlController = TextEditingController();
  final _listKey = GlobalKey<AnimatedListState>();
  final _imageCacheManager = DefaultCacheManager();

  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final images = await directory.list().where((e) => e is File).map((e) => e as File).toList();
    setState(() {
      _imageFiles = images;
    });
  }

  Future<void> _downloadImage(String url) async {
    final cachedImage = await _imageCacheManager.getSingleFile(url);
    final directory = await getApplicationDocumentsDirectory();
    final newFile = await cachedImage.copy('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    _imageFiles.add(newFile);
    _listKey.currentState?.insertItem(_imageFiles.length - 1);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Downloader'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter image URL',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () async {
                    await _downloadImage(_urlController.text);
                    _urlController.clear();
                  },
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _imageFiles.length,
              itemBuilder: (context, index, animation) {
                final file = _imageFiles[index];
                return FadeTransition(
                  opacity: animation,
                  child: ListTile(
                    leading: Image.file(file),
                    title: Text(file.path.split('/').last),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
