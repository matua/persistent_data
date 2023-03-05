import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({Key? key, required this.imageFile}) : super(key: key);

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: imageFile.path,
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
