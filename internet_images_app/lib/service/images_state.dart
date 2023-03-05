import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:internet_images_app/repo/repo_control.dart';

class ImagesState with ChangeNotifier {
  late String _localPath;
  final List<File> _imageFiles = [];

  Future<void> initLocalPath() async {
    _localPath = await RepoControl.localPath;
  }

  List<File> getAllImages() {
    final directory = Directory(_localPath);
    final images = directory.listSync().whereType<File>().toList();
    return images;
  }

  void saveImage(File image) async {
    final directory = _localPath;
    final newFile = await image.copy('$directory/${DateTime.now().millisecondsSinceEpoch}.jpg');
    _imageFiles.add(newFile);
    notifyListeners();
  }
}
