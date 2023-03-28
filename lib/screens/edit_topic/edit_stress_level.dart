import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stress_record_app/models/topic.dart';
import 'package:stress_record_app/screens/edit_topic/edit_topic.dart';

class EditStressScreen extends StatefulWidget {
  static const routeName = '/edit-topic-stress';

  @override
  State<EditStressScreen> createState() => _EditStressScreenState();
}

class _EditStressScreenState extends State<EditStressScreen> {
  TextEditingController _controller = TextEditingController();
  double _value = 5;
  bool _initialized = false;

  void changeValue(double value) {
    setState(() {
      _value = value;
      _controller.text = _value.toStringAsFixed(1);
    });
  }

  void submit(Topic newTopic) async {
    newTopic.stressLevel = double.parse(_controller.text);
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
      changeValue(topic.stressLevel);
    }
    Color darkColor = HSLColor.fromColor(
            Color(int.parse(topic.colorAssociated.substring(6, 16))))
        .withLightness(0.1)
        .toColor();
    return Scaffold(
      backgroundColor: Color(int.parse(topic.colorAssociated.substring(6, 16))),
      appBar: AppBar(
        title: Text('${topic.title}: Stress Level'),
        backgroundColor: darkColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300.w,
              height: 75.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8).w,
                shape: BoxShape.rectangle,
                color:
                    HSLColor.fromColor(darkColor).withLightness(0.2).toColor(),
              ),
              child: Slider(
                value: _value,
                min: 0,
                max: 10,
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue;
                    _controller.text = _value.toStringAsFixed(1);
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: 300.0.w,
              margin: EdgeInsets.only(top: 8).r,
              decoration: BoxDecoration(
                color:
                    HSLColor.fromColor(darkColor).withLightness(0.2).toColor(),
                borderRadius: BorderRadius.circular(8).w,
              ),
              padding: EdgeInsets.all(8).w,
              child: Text(
                'Value: ${_controller.text}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            ElevatedButton(
              onPressed: () {
                submit(topic);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    HSLColor.fromColor(darkColor).withLightness(0.2).toColor()),
                fixedSize: MaterialStateProperty.all(Size(150.w, 50.h)),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
