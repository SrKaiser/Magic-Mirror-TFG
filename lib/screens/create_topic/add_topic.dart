import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:stress_record_app/models/topic.dart';
import 'package:stress_record_app/screens/create_topic/cancel_alert.dart';
import 'package:stress_record_app/screens/topics_panel/topic_panel.dart';
import './charge_level.dart';
import 'package:uuid/uuid.dart';

class AddTopicScreen extends StatefulWidget {
  static const routeName = '/add-topic';

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  TextEditingController _titleController = TextEditingController();
  String appBarTitle = 'Add Topic';
  TextEditingController _placeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String _location = 'Unknown Location';
  Future<void> _getCurrentLocation() async {
    try {
      // Comprobar si la ubicación está activada
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Traducir las coordenadas a una dirección
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Actualizar la información de ubicación
      setState(() {
        _location = placemarks.first.street;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  bool errorExist = false;
  String dateMade = DateFormat.yMd().format(DateTime.now());
  String timeMade;
  final _formKey = GlobalKey<FormState>();
  void _submitData() {
    if (_placeController.text.isEmpty)
      _placeController.text = 'No Place Specified';
    if (_dateController.text.isEmpty)
      _dateController.text = 'No Date Specified';
    if (_timeController.text.isEmpty)
      _timeController.text = 'No Time Specified';
    Topic newTopic = Topic(
      id: Uuid().v4(),
      title: _titleController.text,
      place: _placeController.text,
      date: _dateController.text,
      time: _timeController.text,
      dateCreated: dateMade,
      timeCreated: timeMade,
      placeCreated: 'TBD',
    );

    Navigator.of(context).pop();
    Navigator.of(context)
        .pushNamed(ChargeLevelScreen.routeName, arguments: newTopic);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // currentLocation = getAddressFromLatLng();
    /* addPostFrameCallback() se utiliza para esperar hasta que el widget se 
    haya construido completamente antes de mostrar el diálogo. */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0).w,
            ),
            backgroundColor: Color.fromARGB(255, 8, 54, 85),
            title: Text(
              'What name would you like to give to your topic?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Type here',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0))),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    if (!_titleController.text.isEmpty)
                      appBarTitle = 'New topic: ' + _titleController.text;
                    else {
                      _titleController.text = '#';
                      appBarTitle = 'New topic: Unknown';
                    }
                  });
                  Navigator.of(context).pop(_titleController.text);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Adding topic action was cancelled')),
          );
          Navigator.of(context)
              .pushReplacementNamed(TopicPanelScreen.routeName);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    timeMade = TimeOfDay.now().format(context);
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
          title: Text(appBarTitle),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false,
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
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Please, introduce the following data about the event to be explored:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          addTopicInput('Place:', _placeController),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 60.0.w,
                                  child: Text(
                                    'Date:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
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
                                      color: Color.fromARGB(255, 32, 53, 130),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                              left: 10, top: 6, right: 25)
                                          .r,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _dateController,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp),
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
                                              : EdgeInsets.only(top: 12.0).r,
                                          hintText: 'Choose Date',
                                          hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            fieldLabelText:
                                                'Enter Date With Format: (mm/dd/yyyy)',
                                            builder: (BuildContext context,
                                                Widget child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: Color.fromARGB(
                                                        255, 32, 53, 130),
                                                  ),
                                                ),
                                                child: child,
                                              );
                                            },
                                          ).then((value) {
                                            if (value != null)
                                              _dateController.text =
                                                  DateFormat.yMd()
                                                      .format(value);
                                          });
                                        },
                                      ),
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
                                  width: 60.0.w,
                                  child: Text(
                                    'Time:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
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
                                      color: Color.fromARGB(255, 32, 53, 130),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                              left: 10, top: 6, right: 25)
                                          .r,
                                      child: TextFormField(
                                        readOnly: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp),
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
                                              : EdgeInsets.only(top: 12.0).r,
                                          hintText: 'Choose Time',
                                          hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                            builder: (BuildContext context,
                                                Widget child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: Color.fromARGB(
                                                        255,
                                                        32,
                                                        53,
                                                        130), // Cambia el color del botón OK
                                                  ),
                                                ),
                                                child: child,
                                              );
                                            },
                                          ).then(
                                            (value) {
                                              if (value != null) {
                                                _timeController.text =
                                                    value.format(context);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            'This entry is being made: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0).w,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 60.0.w,
                                  child: Text(
                                    'Place',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
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
                                      color: Color.fromARGB(255, 74, 80, 246),
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.sp),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 15.0).r,
                                        border: InputBorder.none,
                                        hintText: _location,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(
                                          Icons.gps_fixed,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        _getCurrentLocation();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          addTopicFixedData('Date:', '${dateMade}'),
                          addTopicFixedData('Time:', '${timeMade}'),
                          SizedBox(
                            height: 110.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20.h,
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
                      fixedSize: MaterialStateProperty.all(Size(150.w, 50.h)),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                    ),
                  ),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitData();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 8, 54, 85),
                      ),
                      fixedSize: MaterialStateProperty.all(Size(150.w, 50.h)),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget addTopicInput(String inputName, TextEditingController textController) {
  return Padding(
    padding: EdgeInsets.all(12.0).w,
    child: Row(
      children: <Widget>[
        Container(
          width: 60.0.w,
          child: Text(
            inputName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
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
              color: Color.fromARGB(255, 32, 53, 130),
            ),
            child: TextFormField(
              controller: textController,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ).r,
                border: InputBorder.none,
                hintText: 'Type here...',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget addTopicFixedData(String inputName, String hintText) {
  return Padding(
    padding: EdgeInsets.all(12.0).w,
    child: Row(
      children: <Widget>[
        Container(
          width: 60.0.w,
          child: Text(
            inputName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
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
              color: Color.fromARGB(255, 74, 80, 246),
            ),
            child: TextFormField(
              enabled: false,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20).r,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
