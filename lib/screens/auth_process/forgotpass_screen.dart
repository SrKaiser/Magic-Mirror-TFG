import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String _emailErrorMessages(String email) {
    if (email == null || email.isEmpty) {
      return '- Enter your email address';
    } else if (!EmailValidator.validate(email)) {
      return '- Enter a valid email address';
    }
    return null;
  }

  var errorExist = false;
  List<String> _errors = [];

  Future resetPassword() async {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) {
      setState(() {
        errorExist = true;
        _errors = [];
        if (_emailErrorMessages(_emailController.text) != null) {
          _errors.add(_emailErrorMessages(_emailController.text));
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password Reset Email Sent'),
        backgroundColor: Color.fromARGB(255, 23, 7, 113),
      ));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Color.fromARGB(255, 126, 9, 9),
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
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
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0).w,
                    child: Text(
                      'Receive an email to reset your password',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
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
                    height: 65.h,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 45,
                      right: 45,
                    ).r,
                    width: double.infinity,
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
                        resetPassword();
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
