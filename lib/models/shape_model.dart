import 'package:flutter/material.dart';

abstract class Shape {
  final Offset start;

  Shape(this.start);
}

class CircleShape extends Shape {
  final double radius;

  CircleShape(
    Offset start,
    this.radius,
  ) : super(start);
}

class RectangleShape extends Shape {
  final Offset end;

  RectangleShape(
    Offset start,
    this.end,
  ) : super(start);
}

class LineShape extends Shape {
  final Offset end;

  LineShape(
    Offset start,
    this.end,
  ) : super(start);
}
