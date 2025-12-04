import 'package:flutter/material.dart';
import 'dart:typed_data';

class ImageCard extends StatelessWidget {
  final Uint8List imageBytes;
  final int index;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const ImageCard({
    required this.imageBytes,
    required this.index,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.memory(imageBytes, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.favorite_border, color: Colors.red), onPressed: onLike),
                  IconButton(icon: Icon(Icons.comment_outlined, color: Colors.grey[700]), onPressed: onComment),
                  IconButton(icon: Icon(Icons.share_outlined, color: Colors.grey[700]), onPressed: onShare),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
