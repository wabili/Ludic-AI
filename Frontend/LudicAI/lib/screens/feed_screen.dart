import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/image_card.dart';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Uint8List> images = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    fetchNextImage();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchNextImage();
    }
  }

  Future<void> fetchNextImage() async {
    setState(() => isLoading = true);
    final bytes = await api.fetchImage();
    if (bytes != null) {
      setState(() => images.add(bytes));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
      ),
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index < images.length) {
            return ImageCard(
              imageBytes: images[index],
              index: index,
              onLike: () => print('Liked $index'),
              onComment: () => print('Comment $index'),
              onShare: () => print('Share $index'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: isLoading ? CircularProgressIndicator() : SizedBox()),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
