import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:winelist/view.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: View(),
    );
  }
}
