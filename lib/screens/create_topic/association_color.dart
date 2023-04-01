import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssociationColorScreen extends StatefulWidget {
  static const routeName = '/add-topic-associations-color';
  @override
  State<AssociationColorScreen> createState() => _AssociationColorScreenState();
}

class _AssociationColorScreenState extends State<AssociationColorScreen> {
  Color selectedColor = Colors.white;
  int timesSelected = 0;

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Associated Color'),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'What colour do you imagine when you think of this topic?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0.h),
                Container(
                  width: 250.0.w,
                  height: 250.0.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 3.0,
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
                      Color.fromARGB(255, 37, 69, 183),
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
                                  Navigator.of(context).pop(selectedColor);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(270.w, 50.h)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 17, 81, 158)),
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
        ],
      ),
    );
  }
}
