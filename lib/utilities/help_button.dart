import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpButton extends StatelessWidget {
  final Color alertColor;

  Color getContrastColor(Color color) {
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  HelpButton(this.alertColor);
  @override
  Widget build(BuildContext context) {
    Color buttonColor = getContrastColor(alertColor);
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
                          style: TextStyle(color: buttonColor),
                        ),
                        content: Text(
                          "Here below you have different panels with a different theme, you must choose a specific element (animal, tree...) that you associate with your event that causes stress, it is not necessary to choose all of them.",
                          style: TextStyle(color: buttonColor),
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
