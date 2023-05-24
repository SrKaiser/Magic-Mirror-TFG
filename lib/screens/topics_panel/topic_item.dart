import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/topic.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';

import '../edit_topic/edit_topic.dart';

Future<ui.Image> base64ToImage(String base64String) async {
  Uint8List bytes = base64.decode(base64String);
  ui.Codec codec = await ui.instantiateImageCodec(bytes);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

Color getContrastColor(Color color) {
  double luminance =
      (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

  if (luminance > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

class TopicItem extends StatefulWidget {
  final Topic topic;
  TopicItem({this.topic});

  @override
  State<TopicItem> createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> {
  @override
  Widget build(BuildContext context) {
    // Decodificar el string en un arreglo de bytes
    Uint8List bytes = base64.decode(widget.topic.body);
    // Crear un ImageProvider a partir de los bytes decodificados
    ImageProvider img = MemoryImage(bytes);
    double desiredWidth = 90.0;
    double desiredHeight = 150.0;

    ImageProvider resizedImageProvider = ResizeImage(img,
        width: desiredWidth.toInt(), height: desiredHeight.toInt());

    Color textColor = getContrastColor(
        Color(int.parse(widget.topic.colorAssociated.substring(6, 16))));

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(EditTopicScreen.routeName, arguments: widget.topic),
      child: Dismissible(
        key: Key('card_key'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
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
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (_) async {
          User user = FirebaseAuth.instance.currentUser;
          var myTopicsStorage = TopicsStorage(user.uid);
          await myTopicsStorage.deleteTopic(widget.topic);
        },
        background: Container(
          color: Colors.red,
          child: Icon(Icons.delete, color: Colors.white),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(left: 16.0).r,
        ),
        child: Card(
          elevation: 4.0,
          color:
              Color(int.parse(widget.topic.colorAssociated.substring(6, 16))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: resizedImageProvider,
                // height: 110.0.h,
                // width: 150.0.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16.0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.0.h),
                    Text(
                      widget.topic.title,
                      style: TextStyle(
                        fontSize: 26.0.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.0.h),
                    Text(
                      'Place: ${widget.topic.place.toString()}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(height: 8.0.h),
                    Text(
                      'Date: ${widget.topic.date.toString()}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(height: 8.0.h),
                    Text(
                      'Time: ${widget.topic.time.toString()}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(height: 8.0.h),
                    Text(
                      'Stress level: ${widget.topic.stressLevel.toString()}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
