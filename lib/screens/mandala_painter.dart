import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:mandala_maker/blocs/main_bloc.dart';
import 'package:mandala_maker/models/shape_model.dart';

class MandalaPainter extends CustomPainter {
  final MainBloc mainBloc;
  Offset center;

  BuiltList<Shape> _curItems;

  MandalaPainter(this.mainBloc);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    center = Offset(size.width / 2, size.height / 2);
    print(center);

    mainBloc.setMandalaCenter(center);

    paint.color = Colors.grey;
    paint.style = PaintingStyle.stroke;

    _createCenterAxes(canvas, size, paint);

    _curItems = mainBloc.getShapes();
    if(_curItems == null || _curItems.length == 0) return;
    _curItems.forEach((shape) {
      if (shape is CircleShape) {
        _createCircle(canvas, shape.start, shape.radius, paint);
      }

      if (shape is RectangleShape) {
        _createRectangle(canvas, paint, shape.start, shape.end);
      }

      if (shape is LineShape) {
        _createLine(canvas, paint, shape.start, shape.end);
      }
    });
  }

  void _createCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
  }

  void _createRectangle(Canvas canvas, Paint paint, Offset begin, Offset end) {
    canvas.drawRect(Rect.fromPoints(begin, end), paint);
  }

  void _createLine(Canvas canvas, Paint paint, Offset begin, Offset end) {
    canvas.drawLine(begin, end, paint);
  }

  void _createCenterAxes(Canvas canvas, Size size, Paint paint) {
    paint.strokeWidth = 1;
    // canvas.drawLine(
    //     Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // canvas.drawLine(
    //     Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

    var oneUnitEquivalent = 5;
    var maxAllowedUnitsAlongX = size.width / oneUnitEquivalent;
    var maxAllowedUnitsAlongY = size.height / oneUnitEquivalent;

    var i = 1;
    while (i < maxAllowedUnitsAlongX) {
      var y1 = 0.0;//size.height / 2 - 5;
      var y2 = 10.0;

      var x = size.width - (5 * i);

      //paint.strokeWidth = i % 5 == 0 ? 1.5 : 1.0;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);

      i++;
    }

    i = 1;
    while (i < maxAllowedUnitsAlongY) {
      var x1 = 0.0;
      var x2 = 10.0;

      var y = size.height - (5 * i);

      //paint.strokeWidth = i % 5 == 0 ? 1.5 : 1.0;

      canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
      i++;
    }
  }

  @override
  bool shouldRepaint(MandalaPainter oldDelegate) {
    return false;
  }
}
