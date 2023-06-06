import 'package:example/search_feed.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Search Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchFeed(),
    );
  }
}
