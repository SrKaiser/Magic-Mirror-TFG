import 'package:flutter/material.dart';
import 'package:stress_record_app/models/topic.dart';
import 'package:stress_record_app/screens/create_topic/associations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stress_record_app/screens/create_topic/cancel_alert.dart';

class ChargeLevelScreen extends StatefulWidget {
  static const routeName = '/add-topic-charge-level';

  @override
  State<ChargeLevelScreen> createState() => _ChargeLevelScreenState();
}

class _ChargeLevelScreenState extends State<ChargeLevelScreen> {
  double _value = 5;

  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = _value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    var newTopic = ModalRoute.of(context).settings.arguments as Topic;

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CancelAlert();
            });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Charge Level'),
          automaticallyImplyLeading: false,
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
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select how much Stress/Stimulus is associated with the Topic:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      width: 300.w,
                      height: 75.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8).w,
                        color: Color.fromARGB(255, 32, 53, 130),
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
                        color: Color.fromARGB(255, 32, 53, 130),
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
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CancelAlert();
                              });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 8, 54, 85),
                          ),
                          fixedSize:
                              MaterialStateProperty.all(Size(150.w, 50.h)),
                        ),
                        child: Text(
                          'Cancel',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0.sp),
                        ),
                      ),
                      SizedBox(
                        width: 20.0.w,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          newTopic.stressLevel = double.parse(_controller.text);
                          Navigator.of(context).pushReplacementNamed(
                              AssociationsScreen.routeName,
                              arguments: newTopic);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 8, 54, 85),
                          ),
                          fixedSize:
                              MaterialStateProperty.all(Size(150.w, 50.h)),
                        ),
                        child: Text(
                          'Continue',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0.sp),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
