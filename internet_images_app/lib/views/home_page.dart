import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Error: Failed to download image'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ));
      }
    } else {
      _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: const Text('Error: Please enter a valid URL'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var imagesState = context.watch<ImagesState>();
    Future<List<File>> images = imagesState.getAllImages();

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade800,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Image Downloader',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter the URL of the image to download',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
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
                                    : GridView.builder(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                          childAspectRatio: 1.0,
                                        ),
                                        itemCount: images.length,
                                        itemBuilder: (context, index) {
                                          final imageFile = images[index];
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return ImageDetailPage(imageFile: imageFile);
                                              }));
                                            },
                                            child: Hero(
                                              tag: imageFile.path,
                                              child: Image.file(
                                                imageFile,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
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
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    imagesState.deleteAllImages();
                  },
                  child: const Icon(Icons.delete),
                  backgroundColor: Colors.blue.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
