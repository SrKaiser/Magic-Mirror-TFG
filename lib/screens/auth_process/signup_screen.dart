import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

import '../topics_panel/topic_panel.dart';
import '../../utilities/title_app.dart';
import './login_screen.dart';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                  Color.fromRGBO(7, 110, 219, 1),
                  Color.fromRGBO(6, 70, 138, 1),
                  Color.fromRGBO(5, 41, 79, 1)
                ],
                    stops: [
                  0.0,
                  0.5,
                  0.99
                ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter)),
          ),
          SignUpWidget(),
        ],
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

final navigatorKey = GlobalKey<NavigatorState>();
final formKey = GlobalKey<FormState>();

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> _errors = [];
  var errorExist = false;
  var firstPassword;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _emailErrorMessages(String email) {
    if (email == null || email.isEmpty) {
      return '- Enter an email address';
    } else if (!EmailValidator.validate(email)) {
      return '- Enter a valid email address';
    }
    return null;
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

  String _dateErrorMessages(String date) {
    if (date.isEmpty) {
      return '- Pick your birth date';
    }
    return null;
  }

  Future signUp() async {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) {
      setState(() {
        errorExist = true;
        _errors = [];
        if (_emailErrorMessages(_emailController.text) != null) {
          _errors.add(_emailErrorMessages(_emailController.text));
          _errors.add("");
        }
        if (_passwordErrorMessages(_passwordController.text) != null) {
          _errors.add(_passwordErrorMessages(_passwordController.text));
          _errors.add("");
        }

        if (_password2ErrorMessages(_passwordConfirmController.text) != null) {
          _errors.add(_password2ErrorMessages(_passwordConfirmController.text));
          _errors.add("");
        }

        if (_dateErrorMessages(_dateController.text) != null)
          _errors.add(_dateErrorMessages(_dateController.text));
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      final ref = FirebaseDatabase.instance.ref();
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser;
      ref.child("users").child(user.uid).set({
        'id': user.uid,
        'email': _emailController.text.trim(),
        'birth_date': _dateController.text.trim(),
      });

      final img = await getImageFileFromAssets('assets/images/avatar.jpg');
      await FirebaseStorage.instance
          .ref('${user.uid}/profile_photo.jpg')
          .putFile(img);

      Navigator.of(context).pushReplacementNamed(TopicPanelScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        print('El email ya está en uso');
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0).w,
              ),
              backgroundColor: Color.fromARGB(255, 8, 54, 85),
              title: Text(
                'Sign up not completed',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'The email adress you are trying to register with is already used',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      }
    }

    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/temp.jpg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  void iniciarSesion(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleApp(),
              Container(
                height: 55.h,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0).w,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30).w),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 6, right: 25).r,
                  child: TextFormField(
                    validator: (value) {
                      return _emailErrorMessages(value);
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorStyle: TextStyle(fontSize: 0),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      contentPadding: errorExist == true
                          ? EdgeInsets.only(top: 20.0).r
                          : EdgeInsets.only(top: 12.0).r,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontSize: 18.sp,
                        color: Color.fromARGB(179, 0, 0, 0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              Container(
                height: 55.h,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0).w,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30).w),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 6, right: 25).r,
                  child: TextFormField(
                    validator: (value) {
                      return _passwordErrorMessages(value);
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorStyle: TextStyle(fontSize: 0),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      contentPadding: errorExist == true
                          ? EdgeInsets.only(top: 20.0).r
                          : EdgeInsets.only(top: 12.0).r,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 18.sp,
                        color: Color.fromARGB(179, 0, 0, 0),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
              ),
              Container(
                height: 55.h,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0).w,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30).w),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 6, right: 25).r,
                  child: TextFormField(
                    validator: (value) {
                      return _password2ErrorMessages(value);
                    },
                    controller: _passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorStyle: TextStyle(fontSize: 0),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                      contentPadding: errorExist == true
                          ? EdgeInsets.only(top: 20.0).r
                          : EdgeInsets.only(top: 12.0).r,
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        fontSize: 18.sp,
                        color: Color.fromARGB(179, 0, 0, 0),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
              ),
              Container(
                height: 55.h,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0).r,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 6, right: 25).r,
                  child: TextFormField(
                    readOnly: true,
                    controller: _dateController,
                    validator: (value) {
                      return _dateErrorMessages(value);
                    },
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorStyle: TextStyle(fontSize: 0),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                      contentPadding: errorExist == true
                          ? EdgeInsets.only(top: 20.0).r
                          : EdgeInsets.only(top: 12.0).r,
                      hintText: 'Birth Date',
                      hintStyle: TextStyle(
                        fontSize: 18.sp,
                        color: Color.fromARGB(179, 0, 0, 0),
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null)
                          _dateController.text = DateFormat.yMd().format(value);
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: 85.h,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 45, right: 45).r,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 0, 90, 120)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0).w,
                      ),
                    ),
                  ),
                  onPressed: () {
                    signUp();
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic),
                  ),
                  TextButton(
                    onPressed: () => iniciarSesion(context),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 255, 145)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget signUpInput(String title, TextInputType keyboardType, bool isPassword,
    IconData icon, TextEditingController textController) {
  return Container(
    height: 55.h,
    margin: EdgeInsets.fromLTRB(20, 20, 20, 0).w,
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(30).w),
    child: Padding(
      padding: EdgeInsets.only(left: 10, top: 6, right: 25).r,
      child: TextField(
        controller: textController,
        obscureText: isPassword,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: title,
          hintStyle: TextStyle(
            fontSize: 18.sp,
            color: Color.fromARGB(179, 0, 0, 0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    ),
  );
}
