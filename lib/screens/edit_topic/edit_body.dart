import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stress_record_app/models/topic.dart';
import 'package:stress_record_app/screens/edit_topic/edit_topic.dart';
import 'package:stress_record_app/utilities/drawing_painter.dart';

import 'package:stress_record_app/utilities/shapes_painter.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';

GlobalKey _stackBodyKey = GlobalKey();

Future<String> stackToBase64(GlobalKey _key) async {
  RenderRepaintBoundary boundary =
      _key.currentContext.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return base64.encode(byteData.buffer.asUint8List());
}

class EditBodyScreen extends StatefulWidget {
  static const routeName = '/edit-topic-body';

  @override
  State<EditBodyScreen> createState() => _EditBodyScreenState();
}

class _EditBodyScreenState extends State<EditBodyScreen> {
  List<Shape> _shapes = [];
  ShapeType _selectedShape = ShapeType.Circle;

  List<Offset> _points = <Offset>[];
  bool _brushSelected = false;

  Stack bodyShape;

  void submit(Topic newTopic) async {
    newTopic.body = await stackToBase64(_stackBodyKey);
    User user = FirebaseAuth.instance.currentUser;
    var myTopicsStorage = TopicsStorage(user.uid);
    await myTopicsStorage.saveTopic(newTopic);
    Navigator.of(context)
        .pushReplacementNamed(EditTopicScreen.routeName, arguments: newTopic);
  }

  @override
  Widget build(BuildContext context) {
    var topic = ModalRoute.of(context).settings.arguments as Topic;

    Color darkColor = HSLColor.fromColor(
            Color(int.parse(topic.colorAssociated.substring(6, 16))))
        .withLightness(0.1)
        .toColor();

    return Scaffold(
        backgroundColor:
            Color(int.parse(topic.colorAssociated.substring(6, 16))),
        appBar: AppBar(
          title: Text('${topic.title}: Body'),
          backgroundColor: darkColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _stackBodyKey,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        final shape = Shape(
                            _selectedShape,
                            details.localPosition,
                            Color(int.parse(
                                topic.colorAssociated.substring(6, 16))));
                        setState(() {
                          _shapes.add(shape);
                        });
                      },
                      onPanUpdate: _brushSelected == true
                          ? (details) {
                              setState(() {
                                RenderBox referenceBox =
                                    context.findRenderObject() as RenderBox;
                                Offset localPosition = referenceBox
                                    .globalToLocal(details.localPosition);
                                _points = List.from(_points)
                                  ..add(localPosition);
                              });
                            }
                          : null,
                      onPanEnd: (DragEndDetails details) {
                        _points.add(null);
                      },
                      child: Container(
                        height: 610.h,
                        width: 290.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0).w,
                          ),
                          color: Colors.white.withOpacity(0),
                          image: DecorationImage(
                            image: AssetImage('assets/images/body_region.png'),
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: ShapesPainter(_shapes),
                    ),
                    CustomPaint(
                      painter: DrawingPainter(
                          points: _points,
                          color: Color(int.parse(
                              topic.colorAssociated.substring(6, 16)))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 300.w,
                decoration: BoxDecoration(
                  color: darkColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0).w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 1,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedShape = ShapeType.Circle;
                          _brushSelected = false;
                        });
                      },
                      icon: Icon(
                        Icons.circle_outlined,
                        color: Colors.white,
                      ),
                      iconSize: 25.sp,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedShape = ShapeType.Star;
                          _brushSelected = false;
                        });
                      },
                      icon: Icon(
                        Icons.star_border,
                        color: Colors.white,
                      ),
                      iconSize: 30.sp,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedShape = ShapeType.Square;
                          _brushSelected = false;
                        });
                      },
                      icon: Icon(
                        Icons.square_outlined,
                        color: Colors.white,
                      ),
                      iconSize: 25.sp,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _brushSelected = true;
                          _selectedShape = null;
                        });
                      },
                      icon: Icon(
                        Icons.brush,
                        color: Colors.white,
                      ),
                      iconSize: 25.sp,
                    ),
                    IconButton(
                      onPressed: () {
                        _shapes.clear();
                        _points.clear();
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      iconSize: 25.sp,
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0).w,
                              ),
                              backgroundColor: Color.fromARGB(255, 8, 54, 85),
                              title: Text(
                                "Are you sure?",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                "This action cannot be undone.",
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    submit(topic);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      iconSize: 25.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
