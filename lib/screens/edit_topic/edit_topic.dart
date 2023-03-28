import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stress_record_app/models/topic.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:stress_record_app/screens/create_topic/add_association.dart';
import 'package:stress_record_app/screens/edit_topic/edit_body.dart';
import 'package:stress_record_app/screens/edit_topic/edit_color.dart';
import 'package:stress_record_app/screens/edit_topic/edit_information.dart';
import 'package:stress_record_app/screens/edit_topic/edit_stress_level.dart';
import 'package:stress_record_app/screens/topics_panel/topic_panel.dart';

showEditOptions(BuildContext context, Topic topic, Color colorAssociated) {
  BuildContext dialogContext = context;
  Color optionColor = colorAssociated;
  Color alertColor =
      HSLColor.fromColor(colorAssociated).withLightness(0.1).toColor();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: alertColor,
        title: Text(
          'Which aspect of your topic would you like to edit?',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Container(
          color: alertColor,
          height: 285.h,
          width: 400.w,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0.w,
            crossAxisSpacing: 8.0.w,
            // shrinkWrap: true,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(dialogContext).pushNamed(
                      EditInformationScreen.routeName,
                      arguments: topic);
                },
                child: Container(
                  padding: EdgeInsets.all(16.0).w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0).w,
                    color: optionColor,
                  ),
                  child: Center(
                    child: OptionText('Information', 18),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(dialogContext)
                      .pushNamed(EditStressScreen.routeName, arguments: topic);
                },
                child: Container(
                  padding: EdgeInsets.all(16.0).w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0).w,
                    color: optionColor,
                  ),
                  child: Center(
                    child: OptionText('Stress Level', 22),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await Navigator.of(dialogContext)
                      .pushNamed(EditColorScreen.routeName, arguments: topic);
                },
                child: Container(
                  padding: EdgeInsets.all(16.0).w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0).w,
                    color: optionColor,
                  ),
                  child: Center(
                    child: OptionText('Color', 22),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(dialogContext)
                      .pushNamed(EditBodyScreen.routeName, arguments: topic);
                },
                child: Container(
                  padding: EdgeInsets.all(16.0).w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0).w,
                    color: optionColor,
                  ),
                  child: Center(
                    child: OptionText('Body', 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void deleteTopic(BuildContext context, Topic topic, Color colorAssociated) {
  Color alertColor =
      HSLColor.fromColor(colorAssociated).withLightness(0.1).toColor();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0).w,
          ),
          backgroundColor: alertColor,
          title: Text(
            "Are you sure?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "The topic will be deleted forever.",
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
              onPressed: () async {
                User user = FirebaseAuth.instance.currentUser;
                var myTopicsStorage = TopicsStorage(user.uid);
                await myTopicsStorage.deleteTopic(topic);
                // DatabaseReference dbRef = FirebaseDatabase.instance
                //     .ref()
                //     .child("users")
                //     .child(user.uid)
                //     .child("topics");
                // dbRef.child(topic['id']).remove();

                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(TopicPanelScreen.routeName);
              },
            ),
          ],
        );
      });
}

class OptionText extends StatefulWidget {
  final String text;
  final double fontSize;
  OptionText(this.text, this.fontSize);

  @override
  State<OptionText> createState() => _OptionTextState();
}

class _OptionTextState extends State<OptionText> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize.sp,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.0
              ..color = Colors.black,
          ),
        ),
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class EditTopicScreen extends StatefulWidget {
  static const routeName = '/edit-topic';
  const EditTopicScreen({Key key}) : super(key: key);

  @override
  State<EditTopicScreen> createState() => _EditTopicScreenState();
}

class _EditTopicScreenState extends State<EditTopicScreen> {
  Color colorAssociated;

  @override
  Widget build(BuildContext context) {
    var topic = ModalRoute.of(context).settings.arguments as Topic;
    colorAssociated = Color(int.parse(topic.colorAssociated.substring(6, 16)));
    // Decodificar el string en un arreglo de bytes
    Uint8List bytes = base64.decode(topic.body);
    // Crear un ImageProvider a partir de los bytes decodificados
    ImageProvider imageProvider = MemoryImage(bytes);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(TopicPanelScreen.routeName);
      },
      child: Scaffold(
        backgroundColor: colorAssociated,
        appBar: AppBar(
          title: Text('Edit Topic: ${topic.title}'),
          backgroundColor:
              HSLColor.fromColor(colorAssociated).withLightness(0.1).toColor(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(TopicPanelScreen.routeName);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                showEditOptions(context, topic, colorAssociated);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                deleteTopic(context, topic, colorAssociated);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: imageProvider,
                height: 610.h,
                width: 290.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              AddAssociation(),
            ],
          ),
        ),
      ),
    );
  }
}
