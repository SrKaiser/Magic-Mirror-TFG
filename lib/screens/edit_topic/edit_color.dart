import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../models/topic.dart';
import '../edit_topic/edit_topic.dart';

class EditColorScreen extends StatefulWidget {
  static const routeName = '/edit-topic-color';

  @override
  State<EditColorScreen> createState() => _EditColorScreenState();
}

class _EditColorScreenState extends State<EditColorScreen> {
  Color selectedColor = Colors.white;
  bool _initialized = false;

  int timesSelected = 0;

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void submit(Topic newTopic) async {
    newTopic.colorAssociated = selectedColor.toString();
    User user = FirebaseAuth.instance.currentUser;
    var myTopicsStorage = TopicsStorage(user.uid);
    await myTopicsStorage.saveTopic(newTopic);
    Navigator.of(context)
        .pushReplacementNamed(EditTopicScreen.routeName, arguments: newTopic);
  }

  @override
  Widget build(BuildContext context) {
    var topic = ModalRoute.of(context).settings.arguments as Topic;
    if (_initialized == false) {
      _initialized = true;
      changeColor(Color(int.parse(topic.colorAssociated.substring(6, 16))));
    }

    Color darkColor = HSLColor.fromColor(
            Color(int.parse(topic.colorAssociated.substring(6, 16))))
        .withLightness(0.1)
        .toColor();
    return Scaffold(
      backgroundColor: Color(int.parse(topic.colorAssociated.substring(6, 16))),
      appBar: AppBar(
        title: Text('${topic.title}: Color'),
        backgroundColor: darkColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250.0.w,
              height: 250.0.h,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    width: 3.0.w,
                    style: BorderStyle.solid,
                    strokeAlign: StrokeAlign.center),
                color: selectedColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 20.0.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  HSLColor.fromColor(darkColor).withLightness(0.2).toColor(),
                ),
                fixedSize: MaterialStateProperty.all(Size(270.w, 50.h)),
              ),
              child: Text(
                'Click to select the color',
                style: TextStyle(fontSize: 22.sp),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select the color and intensity'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: selectedColor,
                          onColorChanged: changeColor,
                          pickerAreaHeightPercent: 0.5,
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Done'),
                          onPressed: () {
                            setState(() {
                              timesSelected++;
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            if (timesSelected > 0)
              SizedBox(
                height: 30.0.h,
              ),
            if (timesSelected > 0)
              ElevatedButton(
                onPressed: () {
                  submit(topic);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(270.w, 50.h)),
                  backgroundColor: MaterialStateProperty.all(
                    HSLColor.fromColor(darkColor).withLightness(0.1).toColor(),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 22.sp),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
