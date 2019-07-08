import 'package:flutter/material.dart';
import 'package:mandala_maker/screens/drawing_page.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Drawing Shapes",
      home: DrawingPage(),
    );
  }
}
