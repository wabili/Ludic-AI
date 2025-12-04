import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF8E1), Color(0xFFFFF3C2)], // warm happy gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ImageFeed(),
        ),
      )
    );
  }
}

class ImageFeed extends StatefulWidget {
  @override
  _ImageFeedState createState() => _ImageFeedState();
}

class _ImageFeedState extends State<ImageFeed> {
  List<Uint8List> images = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNextImage(); // load first image
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Only fetch a new image when user scrolls near the bottom
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchNextImage();
    }
  }

  Future<void> fetchNextImage() async {
    setState(() => isLoading = true);

    final url = Uri.parse('http://127.0.0.1:8000/generate'); // your API
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          images.add(response.bodyBytes); // add the newly generated image
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(), // allow scrolling always
        itemCount: images.length + 1, // extra for loader
        itemBuilder: (context, index) {
          if (index < images.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.memory(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border, color: Colors.red),
                            onPressed: () {
                              // TODO: Handle like action
                              print('Liked image $index');
                            },
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.comment_outlined, color: Colors.grey[700]),
                            onPressed: () {
                              // TODO: Handle comment action
                              print('Comment on image $index');
                            },
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.share_outlined, color: Colors.grey[700]),
                            onPressed: () {
                              // TODO: Handle share action
                              print('Share image $index');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: isLoading ? CircularProgressIndicator() : SizedBox(),
              ),
            );
          }
        }
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
