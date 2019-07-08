import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mandala_maker/blocs/main_bloc.dart';
import 'package:mandala_maker/models/shape_model.dart';

import 'mandala_painter.dart';

enum Painters { line, rectangle, circle }

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  Painters _activePainter;

  bool _isSelected(Painters p) => _activePainter == p;
  Color _activeColor = Colors.black;
  Color _inactiveColor = Colors.black38;
  bool _submitFnIsNull = true;

  TextEditingController x1Controller = TextEditingController();
  TextEditingController y1Controller = TextEditingController();
  TextEditingController x2Controller = TextEditingController();
  TextEditingController y2Controller = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  Offset _tappedLocation;

  MainBloc mainBloc;

  String _getTitleText() {
    var text = "Add a ";
    switch (_activePainter) {
      case Painters.circle:
        text = text + "circle";
        break;
      case Painters.rectangle:
        text = text + "circle";
        break;
      case Painters.line:
        text = text + "line";
        break;
    }

    return text;
  }

  @override
  void initState() {
    super.initState();

    mainBloc = MainBloc();

    SystemChrome.setEnabledSystemUIOverlays([]);
    _activePainter = Painters.circle;
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomSheet: Container(
          height: 150.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    color: _isSelected(Painters.circle)
                        ? _activeColor
                        : _inactiveColor,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      setState(() {
                        this._activePainter = Painters.circle;
                      });
                    },
                  ),
                  IconButton(
                    color: _isSelected(Painters.line)
                        ? _activeColor
                        : _inactiveColor,
                    icon: Icon(Icons.linear_scale),
                    onPressed: () {
                      setState(() {
                        this._activePainter = Painters.line;
                      });
                    },
                  ),
                  IconButton(
                    color: _isSelected(Painters.rectangle)
                        ? _activeColor
                        : _inactiveColor,
                    icon: Icon(Icons.add_box),
                    onPressed: () {
                      setState(() {
                        this._activePainter = Painters.rectangle;
                      });
                    },
                  )
                ],
              ),
              FlatButton(
                child: Text("Clear"),
                onPressed: mainBloc.clearShapeList
              ),
              FlatButton(
                child: Text("Preview"),
                onPressed: () {},
              ),              
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: GestureDetector(
                    child: CustomPaint(
                      painter: MandalaPainter(mainBloc),
                      size: Size(mediaSize.width, mediaSize.height),
                    ),
                    onTapDown: (TapDownDetails tdd) {
                      RenderBox getBox = context.findRenderObject();

                      _tappedLocation =
                          getBox.globalToLocal(tdd.globalPosition);

                      //mainBloc.setTappedLocation(tdd.globalPosition);

                      return showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              children: <Widget>[
                                StreamBuilder(
                                    stream: mainBloc.mandalaCenter,
                                    builder:
                                        (_, AsyncSnapshot<Offset> centerSnap) {
                                      if (!centerSnap.hasData)
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      return Container(
                                          margin: EdgeInsets.all(12.0),
                                          child: Column(children: <Widget>[
                                            Text(
                                              _getTitleText(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title,
                                            ),
                                            Divider(),
                                            _getX1Y1Points(centerSnap.data),
                                            (_activePainter == Painters.circle)
                                                ? _getRadius()
                                                : _getX2Y2Points(
                                                    centerSnap.data),
                                            _getSubmitBtn()
                                          ]));
                                    })
                              ],
                            );
                          });
                    })),
          ],
        ));
  }

  Offset _relativePoint(Offset manadalaCenter, Offset selectedPoint) {
    return selectedPoint;
    // double dx = selectedPoint.dx - manadalaCenter.dx;
    // double dy = selectedPoint.dy - manadalaCenter.dy;
    // return Offset(dx, dy);
  }

  Widget _getX1Y1Points(Offset manadalaCenter) {
    var tappedRelative = _relativePoint(manadalaCenter, _tappedLocation);

    x1Controller.text = tappedRelative.dx.toStringAsFixed(3);
    y1Controller.text = tappedRelative.dy.toStringAsFixed(3);
    return Container(
      child: Row(
        children: <Widget>[
          Text("Start X1"),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: x1Controller,
              onChanged: (val) {
                _setSubmitBtnState();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))),
            ),
          )),
          Text("Start Y1"),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: y1Controller,
              onChanged: (val) {
                _setSubmitBtnState();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))),
            ),
          )),
        ],
      ),
    );
  }

  Widget _getRadius() {
    radiusController.text = "";
    mainBloc.updateSubmitBtnState(false);
    return Container(
      child: Row(
        children: <Widget>[
          Text("Radius"),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: radiusController,
              onChanged: (val) {
                _setSubmitBtnState();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))),
            ),
          )),
        ],
      ),
    );
  }

  Widget _getX2Y2Points(Offset manadalaCenter) {
    x2Controller.text = "";
    y2Controller.text = "";
    mainBloc.updateSubmitBtnState(false);
    return Container(
      child: Row(
        children: <Widget>[
          Text("End X2"),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: x2Controller,
              onChanged: (val) {
                _setSubmitBtnState();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))),
            ),
          )),
          Text("End Y2"),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: y2Controller,
              onChanged: (val) {
                _setSubmitBtnState();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))),
            ),
          )),
        ],
      ),
    );
  }

  Widget _getSubmitBtn() {
    return StreamBuilder(
      initialData: false,
      stream: mainBloc.submitIsActive,
      builder: (_, AsyncSnapshot<bool> snap) {
        return RaisedButton(
          child: Text("Add"),
          onPressed: snap.data == null || snap.data == false
              ? null
              : () {
                  var startX = double.tryParse(x1Controller.text);
                  var startY = double.tryParse(y1Controller.text);

                  if (_activePainter == Painters.circle) {
                    var radius = double.tryParse(radiusController.text);
                    var circleShape =
                        CircleShape(Offset(startX, startY), radius);

                    mainBloc.addToShapeList(circleShape);
                    Navigator.pop(context);
                  }

                  if (_activePainter == Painters.rectangle ||
                      _activePainter == Painters.line) {
                    var endX = double.tryParse(x2Controller.text);
                    var endY = double.tryParse(y2Controller.text);

                    if (_activePainter == Painters.rectangle) {
                      var shape = RectangleShape(
                          Offset(startX, startY), Offset(endX, endY));

                      mainBloc.addToShapeList(shape);
                      Navigator.pop(context);
                    }

                    if (_activePainter == Painters.line) {
                      var shape = LineShape(
                          Offset(startX, startY), Offset(endX, endY));

                      mainBloc.addToShapeList(shape);
                      Navigator.pop(context);
                    }
                  }
                },
        );
      },
    );
  }

  _setSubmitBtnState() {
    if (_activePainter == Painters.circle) {
      var fnIsNull = _stringIsNullOrEmpty(x1Controller.text) ||
          _stringIsNullOrEmpty(y1Controller.text) ||
          _stringIsNullOrEmpty(radiusController.text);

      mainBloc.updateSubmitBtnState(!fnIsNull);
      return;
    }

    var fnIsNull = _stringIsNullOrEmpty(x1Controller.text) ||
        _stringIsNullOrEmpty(y1Controller.text) ||
        _stringIsNullOrEmpty(x2Controller.text) ||
        _stringIsNullOrEmpty(y2Controller.text);

    mainBloc.updateSubmitBtnState(!fnIsNull);
  }

  bool _stringIsNullOrEmpty(String s) {
    if (s == "" || s == null) return true;
    return false;
  }
}
