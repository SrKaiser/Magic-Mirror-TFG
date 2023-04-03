import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/topic.dart';
import '../edit_topic/edit_topic.dart';

class EditInformationScreen extends StatefulWidget {
  static const routeName = '/edit-topic-information';

  @override
  State<EditInformationScreen> createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  bool errorExist = false;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void initTexts(Topic topic) {
    setState(() {
      _titleController.text = topic.title;
      _placeController.text = topic.place;
      _dateController.text = topic.date;
      _timeController.text = topic.time;
    });
  }

  void submit(Topic newTopic) async {
    newTopic.title = _titleController.text;
    newTopic.place = _placeController.text;
    newTopic.date = _dateController.text;
    newTopic.time = _timeController.text;
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
      initTexts(topic);
    }

    Color darkColor = HSLColor.fromColor(
            Color(int.parse(topic.colorAssociated.substring(6, 16))))
        .withLightness(0.1)
        .toColor();
    return Scaffold(
      backgroundColor: Color(int.parse(topic.colorAssociated.substring(6, 16))),
      appBar: AppBar(
        title: Text('${topic.title}: Information'),
        backgroundColor: darkColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0).w,
        child: Column(
          children: [
            addTopicInput('Title', _titleController, darkColor, topic.title),
            addTopicInput('Place', _placeController, darkColor, topic.place),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6).w,
                      color: darkColor,
                    ),
                    width: 70.0.w,
                    height: 50.0.h,
                    child: Center(
                      child: Text(
                        'Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0.w,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6).w,
                        color: darkColor,
                      ),
                      width: 70.0.w,
                      height: 50.0.h,
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 0),
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          contentPadding: errorExist == true
                              ? EdgeInsets.only(top: 20.0).r
                              : EdgeInsets.only(top: 15.0).r,
                        ),
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            fieldLabelText:
                                'Enter Date With Format: (mm/dd/yyyy)',
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        darkColor, // Cambia el color del botón OK
                                  ),
                                ),
                                child: child,
                              );
                            },
                          ).then((value) {
                            if (value != null)
                              _dateController.text =
                                  DateFormat.yMd().format(value);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0).w,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 70.0.w,
                    height: 50.0.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6).w,
                      color: darkColor,
                    ),
                    child: Center(
                      child: Text(
                        'Time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0.w,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6).w,
                        color: darkColor,
                      ),
                      width: 70.0.w,
                      height: 50.0.h,
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        controller: _timeController,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 0),
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.timer,
                            color: Colors.white,
                          ),
                          contentPadding: errorExist == true
                              ? EdgeInsets.only(top: 20.0).r
                              : EdgeInsets.only(top: 15.0).r,
                        ),
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        darkColor, // Cambia el color del botón OK
                                  ),
                                ),
                                child: child,
                              );
                            },
                          ).then(
                            (value) {
                              if (value != null) {
                                _timeController.text = value.format(context);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
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

Widget addTopicInput(String inputName, TextEditingController textController,
    Color darkColor, String hintText) {
  return Padding(
    padding: const EdgeInsets.all(12.0).w,
    child: Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6).w,
            color: darkColor,
          ),
          width: 70.0.w,
          height: 50.0.h,
          child: Center(
            child: Text(
              inputName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0.w,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6).w,
              color: darkColor,
            ),
            width: 70.0.w,
            height: 50.0.h,
            child: TextFormField(
              controller: textController,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ).r,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
