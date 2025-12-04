import 'package:flutter/material.dart';
import 'screens/feed_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laugh AI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AppBackgroundWrapper(child: FeedScreen()),
    );
  }
}

class AppBackgroundWrapper extends StatelessWidget {
  final Widget child;

  const AppBackgroundWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E1), // soft pastel yellow
            Color(0xFFFFF3C2), // warm happy peach
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // IMPORTANT
        body: child,
      ),
    );
  }
}