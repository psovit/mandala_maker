import 'dart:ui';

import 'package:mandala_maker/models/shape_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:built_collection/built_collection.dart';

class MainBloc {
  var _ls = BuiltList<Shape>();

  BuiltList<Shape> getShapes() {
    return _ls;
  }

  addToShapeList(Shape s) {
    _ls = _ls.rebuild((b) => b..add(s));
  }

  clearShapeList() {
    _ls = BuiltList<Shape>();
  }

  var _submitBtnStateController = BehaviorSubject<bool>();
  Stream<bool> get submitIsActive => _submitBtnStateController.stream;

  updateSubmitBtnState(bool value) => _submitBtnStateController.sink.add(value);

  var _tappedLocationController = BehaviorSubject<Offset>();
  Stream<Offset> get tappedLocation => _tappedLocationController.stream;

  var _mandalaCenterController = BehaviorSubject<Offset>();
  Stream<Offset> get mandalaCenter => _mandalaCenterController.stream;

  setTappedLocation(Offset offset) =>
      _tappedLocationController.sink.add(offset);

  setMandalaCenter(Offset centerPoint) =>
      _mandalaCenterController.sink.add(centerPoint);

  dispose() {
    _tappedLocationController.close();
    _mandalaCenterController.close();
    _submitBtnStateController.close();
  }
}
