import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:internet_images_app/repo/repo_control.dart';

class ImagesState with ChangeNotifier {
  final List<File> _imageFiles = [];

  Future<List<File>> getAllImages() async {
    final directory = Directory(await RepoControl.localPath);
    final images = directory
        .listSync()
        .where((file) {
          return FileSystemEntity.isFileSync(file.path) && file.path.toLowerCase().endsWith('.jpg') ||
              (file.path.toLowerCase().endsWith('.jpeg') ||
                  file.path.toLowerCase().endsWith('.png') ||
                  file.path.toLowerCase().endsWith('.bmp') ||
                  file.path.toLowerCase().endsWith('.gif') ||
                  file.path.toLowerCase().endsWith('.webp') ||
                  file.path.toLowerCase().endsWith('.tiff') ||
                  file.path.toLowerCase().endsWith('.svg') ||
                  file.path.toLowerCase().endsWith('.ico') ||
                  file.path.toLowerCase().endsWith('.jfif') ||
                  file.path.toLowerCase().endsWith('.pjpeg') ||
                  file.path.toLowerCase().endsWith('.pjp'));
        })
        .map((file) => File(file.path))
        .toList();

    // sort the images by last modified time in descending order
    images.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return images;
  }

  void saveImage(Uint8List imageBytes) async {
    final directory = await RepoControl.localPath;
    final newFile = File('$directory/${DateTime.now().millisecondsSinceEpoch}.jpg');
    newFile.writeAsBytes(imageBytes);
    _imageFiles.add(newFile);
    notifyListeners();
  }

  void deleteAllImages() async {
    final directory = Directory(await RepoControl.localPath);
    final images = directory
        .listSync()
        .where((file) {
          return FileSystemEntity.isFileSync(file.path) && file.path.toLowerCase().endsWith('.jpg') ||
              (file.path.toLowerCase().endsWith('.jpeg') ||
                  file.path.toLowerCase().endsWith('.png') ||
                  file.path.toLowerCase().endsWith('.bmp') ||
                  file.path.toLowerCase().endsWith('.gif') ||
                  file.path.toLowerCase().endsWith('.webp') ||
                  file.path.toLowerCase().endsWith('.tiff') ||
                  file.path.toLowerCase().endsWith('.svg') ||
                  file.path.toLowerCase().endsWith('.ico') ||
                  file.path.toLowerCase().endsWith('.jfif') ||
                  file.path.toLowerCase().endsWith('.pjpeg') ||
                  file.path.toLowerCase().endsWith('.pjp'));
        })
        .map((file) => File(file.path))
        .toList();

    for (var file in images) {
      await file.delete();
    }

    _imageFiles.clear();
    notifyListeners();
  }
}
