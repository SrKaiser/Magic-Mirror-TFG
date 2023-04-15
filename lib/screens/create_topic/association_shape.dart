import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magic_mirror/utilities/inactivity_detector.dart';

import '/utilities/drawing_painter.dart';
import '../../utilities/shapes_painter.dart';
import 'dart:convert';
import 'dart:typed_data';

class AssociationShapeScreen extends StatefulWidget {
  static const routeName = '/add-topic-associations-shape';
  const AssociationShapeScreen({Key key}) : super(key: key);

  @override
  State<AssociationShapeScreen> createState() => _AssociationShapeScreenState();
}

class _AssociationShapeScreenState extends State<AssociationShapeScreen>
    with InactivityDetectorMixin<AssociationShapeScreen> {
  List<Shape> _shapes = [];
  ShapeType _selectedShape = ShapeType.Circle;
  List<Offset> _points = <Offset>[];
  bool _brushSelected = false;
  Stack bodyShape;
  bool _initialized = false;
  ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (_initialized == false) {
      _initialized = true;
      String bodyRegion = args['bodyRegion'];
      // Decodificar el string en un arreglo de bytes
      Uint8List bytes = base64.decode(bodyRegion);
      // Crear un ImageProvider a partir de los bytes decodificados
      imageProvider = MemoryImage(bytes);
    }

    Color associatedColor = args['color'];

    return buildInactivityDetector(
      context,
      Scaffold(
        appBar: AppBar(
          title: Text('Associated Shape'),
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(7, 110, 219, 1),
                  Color.fromRGBO(6, 70, 138, 1),
                  Color.fromRGBO(5, 41, 79, 1),
                ],
                stops: [0.0, 0.5, 0.99],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Draw the shape of your sense',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.h,
                ),
                bodyShape = Stack(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        final shape = Shape(_selectedShape,
                            details.localPosition, associatedColor);
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
                      onPanEnd: (DragEndDetails details) => _points.add(null),
                      child: Container(
                        height: 580.h,
                        width: 260.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0).w,
                          ),
                          color: Colors.white.withOpacity(0),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: ShapesPainter(_shapes),
                    ),
                    CustomPaint(
                      painter: DrawingPainter(
                          points: _points, color: associatedColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 300.w,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 32, 53, 130),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)).w,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1.w,
                        blurRadius: 6.w,
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
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop(bodyShape);
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
          ),
        ]),
      ),
    );
  }

  @override
  void didPop() {
    // TODO: implement didPop
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
  }
}
