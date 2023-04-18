import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/topics_panel/topic_panel.dart';

class CancelAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        "You will lose all of your progress.",
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
            Navigator.of(context)
                .pushReplacementNamed(TopicPanelScreen.routeName);
          },
        ),
      ],
    );
  }
}
