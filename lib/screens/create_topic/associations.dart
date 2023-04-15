import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:magic_mirror/screens/other_attributes/associations_grid.dart';
import 'package:magic_mirror/utilities/help_button.dart';
import 'package:magic_mirror/utilities/inactivity_detector.dart';

import '../../models/topic.dart';
import '../../utilities/cancel_alert.dart';
import '../topics_panel/topic_panel.dart';
import './association_shape.dart';
import './association_body_region.dart';
import './association_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

GlobalKey _stackRegionKey = GlobalKey();
GlobalKey _stackBodyKey = GlobalKey();

Future<String> stackToBase64(GlobalKey _key) async {
  RenderRepaintBoundary boundary =
      _key.currentContext.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return base64.encode(byteData.buffer.asUint8List());
}

class AssociationsScreen extends StatefulWidget {
  static const routeName = '/add-topic-associations';

  @override
  State<AssociationsScreen> createState() => _AssociationsScreenState();
}

class _AssociationsScreenState extends State<AssociationsScreen>
    with InactivityDetectorMixin<AssociationsScreen> {
  int numImportantAssociation = 0;
  Color _associatedColor;
  Stack bodyRegion;
  Stack body;

  Future<void> submit(Topic newTopic) async {
    newTopic.body = await stackToBase64(_stackBodyKey);
    newTopic.colorAssociated = _associatedColor.toString();
    User user = FirebaseAuth.instance.currentUser;
    var myTopicsStorage = TopicsStorage(user.uid);
    await myTopicsStorage.saveTopic(newTopic);
    Navigator.of(context).pushReplacementNamed(TopicPanelScreen.routeName);
    // final ref = FirebaseDatabase.instance.ref();
    // String key = ref.child("users").child(user.uid).child("topics").push().key;
    // ref.child("users").child(user.uid).child("topics").child(key).set({
    // 'id': key,
    // 'title': newTopic.title,
    // 'place': newTopic.place,
    // 'date': newTopic.date,
    // 'time': newTopic.time,
    // 'place_created': newTopic.placeCreated,
    // 'time_created': newTopic.timeCreated,
    // 'date_created': newTopic.dateCreated,
    // 'stress_level': newTopic.stressLevel,
    // 'color_associated': newTopic.colorAssociated,
    // 'body': newTopic.body,
    // });
  }

  @override
  Widget build(BuildContext context) {
    var newTopic = ModalRoute.of(context).settings.arguments as Topic;

    return buildInactivityDetector(
      context,
      WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CancelAlert();
              });
        },
        child: Scaffold(
          backgroundColor:
              _associatedColor == null ? Colors.white : _associatedColor,
          appBar: AppBar(
            title: Text('Associations'),
            automaticallyImplyLeading: false,
            backgroundColor: _associatedColor == null
                ? Color.fromARGB(255, 32, 53, 130)
                : HSLColor.fromColor(_associatedColor)
                    .withLightness(0.1)
                    .toColor(),
            actions: [
              if (numImportantAssociation == 3)
                IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CancelAlert();
                        });
                  },
                ),
              if (numImportantAssociation == 3)
                IconButton(
                  icon: Icon(
                    Icons.save,
                  ),
                  onPressed: () {
                    submit(newTopic);
                  },
                ),
            ],
          ),
          body: Stack(
            children: [
              if (numImportantAssociation == 0)
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
              // Fondo con el título centrado
              if (numImportantAssociation == 0)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 64, horizontal: 16).r,
                  child: Column(
                    children: [
                      Text(
                        'You will now start to create associations that relate to your event.\n\n To enter the first one press the '
                        'Associations'
                        ' button.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              if (numImportantAssociation == 2)
                Center(
                  child:
                      RepaintBoundary(key: _stackRegionKey, child: bodyRegion),
                ),
              if (numImportantAssociation > 2)
                Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: _stackBodyKey,
                        child: body,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      HelpButton(_associatedColor),
                      SizedBox(
                        height: 20.h,
                      ),
                      AssociationsGrid(context, newTopic),
                    ],
                  ),
                )),

              Center(
                child: Stack(
                  children: <Widget>[
                    Text(
                      newTopic.title,
                      style: TextStyle(
                        fontSize: 48.0.sp,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6.0.w
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      newTopic.title,
                      style: TextStyle(
                        fontSize: 48.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido que se coloca encima
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(16.0).w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (numImportantAssociation == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 40.0.w,
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AssociationColorScreen.routeName)
                                    .then((value) {
                                  setState(() {
                                    if (value != null)
                                      numImportantAssociation++;
                                    _associatedColor = value;
                                  });
                                });
                              },
                              elevation: 10.0,
                              fillColor: Color.fromARGB(255, 10, 38, 88),
                              shape: CircleBorder(),
                              constraints: BoxConstraints.tightFor(
                                width: 175.0.w,
                                height: 125.0.h,
                              ),
                              child: Text(
                                "Associations",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 40.0.w,
                            ),
                          ],
                        ),
                      if (numImportantAssociation == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 40.0.w,
                            ),
                            RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(
                                          AssociationBodyScreen.routeName,
                                          arguments: _associatedColor)
                                      .then((value) {
                                    setState(() {
                                      if (value != null)
                                        numImportantAssociation++;
                                      bodyRegion = value;
                                    });
                                  });
                                },
                                elevation: 3.0,
                                fillColor: HSLColor.fromColor(_associatedColor)
                                    .withLightness(0.1)
                                    .toColor(),
                                shape: CircleBorder(),
                                constraints: BoxConstraints.tightFor(
                                  width: 175.0.w,
                                  height: 125.0.h,
                                ),
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/body_region.png'))),
                            Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 40.0.w,
                            ),
                          ],
                        ),
                      if (numImportantAssociation == 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 40.0.w,
                            ),
                            RawMaterialButton(
                              onPressed: () async {
                                String bodyRegion =
                                    await stackToBase64(_stackRegionKey);
                                Navigator.of(context).pushNamed(
                                    AssociationShapeScreen.routeName,
                                    arguments: {
                                      'bodyRegion': bodyRegion,
                                      'color': _associatedColor,
                                    }).then((value) {
                                  setState(() {
                                    if (value != null)
                                      numImportantAssociation++;
                                    body = value;
                                  });
                                });
                              },
                              elevation: 3.0,
                              fillColor: HSLColor.fromColor(_associatedColor)
                                  .withLightness(0.1)
                                  .toColor(),
                              shape: CircleBorder(),
                              constraints: BoxConstraints.tightFor(
                                width: 175.0.w,
                                height: 125.0.h,
                              ),
                              child: Text(
                                "Draw the\nshape",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 40.0.w,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 120.h,
                      ),
                      if (numImportantAssociation < 3) cancelButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class cancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Color.fromARGB(255, 130, 15, 6),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CancelAlert();
            });
      },
      child: Container(
        width: 48.0.w,
        height: 48.0.h,
        child: Center(
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
