import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stress_record_app/screens/auth_process/login_screen.dart';

import '../../drawer/drawer.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

final navigatorKey = GlobalKey<NavigatorState>();
final formKey = GlobalKey<FormState>();

class _SettingsScreenState extends State<SettingsScreen> {
  var errorExist = false;

  var firstPassword;
  List<String> _errors = [];
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  TextEditingController _urlController = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String _passwordErrorMessages(String password) {
    if (password == null || password.isEmpty) {
      return '- Enter a password';
    } else if (password.length < 6) {
      return '- Enter min. 6 characters password';
    }
    firstPassword = password;
    return null;
  }

  String _password2ErrorMessages(String password2) {
    if (password2 == null || password2.isEmpty) {
      return '- Enter the confirm password';
    } else if (password2.length < 6) {
      return '- Enter min. 6 characters confirm password';
    } else if (firstPassword != password2)
      return '- Both passwords must be equal';
    return null;
  }

  void saveChanges() {
    bool isValid = formKey.currentState.validate();
    if (!isValid) {
      setState(() {
        errorExist = true;
        _errors = [];

        if (_passwordErrorMessages(_passwordController.text) != null) {
          _errors.add(_passwordErrorMessages(_passwordController.text));
          _errors.add("");
        }

        if (_password2ErrorMessages(_passwordConfirmController.text) != null) {
          _errors.add(_password2ErrorMessages(_passwordConfirmController.text));
        }
      });

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0).w,
            ),
            backgroundColor: Color.fromARGB(255, 8, 54, 85),
            title: Text(
              'Info',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _errors.map((error) {
                return Text(
                  error,
                  style: TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ],
          );
        },
      );
      return null;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      FirebaseAuth.instance.currentUser
          .updatePassword(_passwordController.text.trim());
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }

    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  String birthDate;
  String imageUrl;
  Image image;
  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.ref();
    databaseReference
        .child('users')
        .child(user.uid)
        .child('birth_date')
        .once()
        .then((DatabaseEvent snapshot) {
      setState(() {
        birthDate = snapshot.snapshot.value;
      });
    });

    super.initState();
  }

  Future<String> downloadPhoto() async {
    User user = FirebaseAuth.instance.currentUser;
    String url = await FirebaseStorage.instance
        .ref('${user.uid}/profile_photo.jpg')
        .getDownloadURL();
    return url;
  }

  File _imageFile;
  Future<void> _getImageFromGallery() async {
    var galleryPermissionStatus = await Permission.storage.status;
    if (galleryPermissionStatus.isDenied) {
      await Permission.storage.request();
    }
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _takePicture() async {
    var cameraPermissionStatus = await Permission.camera.status;
    if (cameraPermissionStatus.isDenied) {
      await Permission.camera.request();
    }

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  void savePhoto() {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseStorage.instance.ref('${user.uid}/profile_photo.jpg').delete();
    FirebaseStorage.instance
        .ref('${user.uid}/profile_photo.jpg')
        .putFile(_imageFile);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Photo Saved Correctly'),
      backgroundColor: Color.fromARGB(255, 23, 7, 113),
    ));
  }

  void showImageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 32, 53, 130),
          title: Text(
            'Where do you want to get the photo from?',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: Container(
            color: Color.fromARGB(255, 32, 53, 130),
            height: 155.h,
            width: 500.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _getImageFromGallery();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0).w,
                          color: Color.fromARGB(255, 47, 81, 206),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gallery',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp),
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Icon(
                              Icons.area_chart_rounded,
                              color: Colors.white,
                              size: 28.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        _takePicture();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0).w,
                          color: Color.fromARGB(255, 47, 81, 206),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Camera',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                              ),
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 28.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: AppDrawer(),
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
            child: Padding(
              padding: EdgeInsets.all(20.0).w,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Patient User',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () => showImageOptions(context),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(120),
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child: _imageFile == null
                                ? FutureBuilder(
                                    future: downloadPhoto(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Image.network(
                                          snapshot.data,
                                          fit: BoxFit.cover,
                                        );
                                      } else
                                        return null;
                                    },
                                  )
                                : Image.file(
                                    _imageFile,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => showImageOptions(context),
                            child: Text(
                              'Change Photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 3, 35, 94),
                              padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0)
                                  .r,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0).w,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              savePhoto();
                            },
                            child: Text(
                              'Save Photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 3, 35, 94),
                              padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0)
                                  .r,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0).w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12).w,
                          color: Color.fromARGB(255, 52, 88, 217),
                        ),
                        child: TextField(
                          enabled: false,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            hintText: FirebaseAuth.instance.currentUser.email,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12).w,
                          color: Color.fromARGB(255, 52, 88, 217),
                        ),
                        child: TextField(
                          enabled: false,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.date_range_outlined,
                              color: Colors.white,
                            ),
                            hintText: birthDate,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12).w,
                          color: Color.fromARGB(255, 52, 88, 217),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return _passwordErrorMessages(value);
                          },
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorStyle: TextStyle(fontSize: 0),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            contentPadding: errorExist == true
                                ? EdgeInsets.only(top: 20.0).r
                                : EdgeInsets.only(top: 12.0).r,
                            hintText: 'New password',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12).w,
                          color: Color.fromARGB(255, 52, 88, 217),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            return _password2ErrorMessages(value);
                          },
                          style: TextStyle(color: Colors.white),
                          controller: _passwordConfirmController,
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorStyle: TextStyle(fontSize: 0),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock_open,
                              color: Colors.white,
                            ),
                            contentPadding: errorExist == true
                                ? EdgeInsets.only(top: 20.0).r
                                : EdgeInsets.only(top: 12.0).r,
                            hintText: 'Confirm new password',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveChanges();
                        },
                        child: Text(
                          'Save New Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 3, 35, 94),
                          padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0)
                              .r,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0).w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
