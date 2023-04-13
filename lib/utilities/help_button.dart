import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpButton extends StatelessWidget {
  final Color alertColor;

  HelpButton(this.alertColor);
  @override
  Widget build(BuildContext context) {
    Color buttonColor = Colors.black;
    if (alertColor.computeLuminance() < 0.07) buttonColor = Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: buttonColor, width: 1),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: IconButton(
              icon: Icon(Icons.help_outline, color: buttonColor),
              color: Colors.transparent,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0).w,
                        ),
                        backgroundColor: alertColor,
                        title: Text(
                          "More Atributtes",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          "Here below you have different panels with a different theme, you must choose a specific element (animal, tree...) that you associate with your event that causes stress, it is not necessary to choose all of them.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    });
              },
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
      ],
    );
  }
}
