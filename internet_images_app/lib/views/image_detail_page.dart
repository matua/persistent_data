import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetailPage extends StatefulWidget {
  final List<File> imageFiles;
  final int initialIndex;

  const ImageDetailPage({
    required this.imageFiles,
    required this.initialIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageFiles.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Image.file(
                  widget.imageFiles[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showHint ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white.withOpacity(0.8),
                child: const Text(
                  'Swipe left or right to view more images',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 10.0,
            right: 10.0,
            child: Text(
              '${_currentIndex + 1} / ${widget.imageFiles.length}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
