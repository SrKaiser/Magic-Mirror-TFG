import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utilities/title_app.dart';

import './signup_screen.dart';
import './forgotpass_screen.dart';
import './welcome_screen.dart';
import '../topics_panel/topic_panel.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          LoginWidget(),
        ],
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  List<String> _errors = [];
  var errorExist = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void signUp(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
  }

  String _emailErrorMessages(String email) {
    if (email == null || email.isEmpty) {
      return '- Enter your email address';
    } else if (!EmailValidator.validate(email)) {
      return '- Enter a valid email address';
    }
    return null;
  }

  String _passwordErrorMessages(String password) {
    if (password == null || password.isEmpty) {
      return '- Enter your password';
    }
    return null;
  }

  Future signIn() async {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) {
      setState(() {
        errorExist = true;
        _errors = [];
        if (_emailErrorMessages(_emailController.text) != null) {
          _errors.add(_emailErrorMessages(_emailController.text));
          _errors.add("");
        }
        if (_passwordErrorMessages(_passwordController.text) != null)
          _errors.add(_passwordErrorMessages(_passwordController.text));
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.of(context).pushReplacementNamed(TopicPanelScreen.routeName);
    } on FirebaseAuthException catch (e) {
      print(e);

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0).w,
            ),
            backgroundColor: Color.fromARGB(255, 8, 54, 85),
            title: Text(
              'Sign in not completed',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'No account with associated email and password',
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
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ],
          );
        },
      );
      navigatorKey.currentState.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 225).r,
              child: Column(
                children: [
                  TitleApp(),
                  Container(
                    height: 55.h,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0).r,
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
                          errorStyle: TextStyle(fontSize: 0.sp),
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          contentPadding: errorExist == true
                              ? EdgeInsets.only(top: 18.0).r
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
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0).r,
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
                          errorStyle: TextStyle(fontSize: 0.sp),
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          contentPadding: errorExist == true
                              ? EdgeInsets.only(top: 18.0).r
                              : EdgeInsets.only(top: 12.0).r,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 18.sp,
                            color: Color.fromARGB(179, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 85.h,
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 50,
                      left: 45,
                      right: 45,
                    ).r,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 0, 90, 120)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0).w,
                          ),
                        ),
                      ),
                      onPressed: () {
                        signIn();
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(ForgotPasswordScreen.routeName),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 255, 145)),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account yet? ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontStyle: FontStyle.italic),
                          ),
                          TextButton(
                            onPressed: () => signUp(context),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 255, 145)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 80.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0).w,
                  topRight: Radius.circular(20.0).w,
                ),
                color: Colors.white,
              ),
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(WelcomeScreen.routeName),
                child: Center(
                  child: Text(
                    'Back to welcome page',
                    style: TextStyle(
                      color: Color.fromRGBO(5, 41, 79, 1),
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
