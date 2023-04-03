import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utilities/drawing_painter.dart';

class AssociationBodyScreen extends StatefulWidget {
  static const routeName = '/add-topic-associations-body';

  @override
  State<AssociationBodyScreen> createState() => _AssociationBodyScreenState();
}

class _AssociationBodyScreenState extends State<AssociationBodyScreen> {
  List<Offset> _points = <Offset>[];
  bool _isDrawing = false;
  Stack bodyRegion;

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      RenderBox referenceBox = context.findRenderObject() as RenderBox;
      Offset localPosition = referenceBox.globalToLocal(details.localPosition);
      _points = List.from(_points)..add(localPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brushColor = ModalRoute.of(context).settings.arguments as Color;
    return Scaffold(
      appBar: AppBar(
        title: Text('Associated Body Region'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.brush),
            onTap: () {
              setState(() {
                _isDrawing = true;
              });
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.delete),
            onTap: () {
              setState(() {
                _points.clear();
              });
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: Icon(Icons.save),
            onTap: () {
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
                          Navigator.of(context).pop(bodyRegion);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Where do you sense this in your body?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0.h,
              ),
              bodyRegion = Stack(
                children: [
                  Container(
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
                    child: GestureDetector(
                      onPanUpdate: _isDrawing ? _handlePanUpdate : null,
                      onPanEnd: (details) => _points.add(null),
                      child: ClipRect(
                        child: CustomPaint(
                          painter: DrawingPainter(
                              points: _points, color: brushColor),
                          size: Size(610.h, 250.w),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
