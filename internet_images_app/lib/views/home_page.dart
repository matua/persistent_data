import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/images_state.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController(text: "https://picsum.photos/200");
  String lastEnteredUrl = '';

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> downloadImage(String url) async {
    final imagesState = context.read<ImagesState>();
    if (url.isNotEmpty) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        imagesState.saveImage(imageBytes);
        _controller.text = url;
      } else {
        _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text('Error: Failed to download image'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var imagesState = context.watch<ImagesState>();
    Future<List<File>> images = imagesState.getAllImages();

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Image Downloader"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter image URL',
                      ),
                      onChanged: (value) {
                        lastEnteredUrl = value;
                      },
                      onSubmitted: (value) {
                        downloadImage(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => downloadImage(_controller.text),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: images,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final images = snapshot.data!;
                    return images.isEmpty
                        ? const Center(
                            child: Text('No images'),
                          )
                        : ListView.builder(
                            key: ValueKey(images.length), // add a unique key
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              final imageFile = images[index];
                              return ListTile(
                                leading: Image.file(imageFile),
                                title: Text(imageFile.path),
                              );
                            },
                          );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            imagesState.deleteAllImages();
          },
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
