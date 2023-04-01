import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './login_screen.dart';

import '../../utilities/styles.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final int _numPages = 6;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0.w),
      height: 8.0.h,
      width: isActive ? 24.0.w : 16.0.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color.fromARGB(255, 12, 143, 204),
        borderRadius: BorderRadius.all(Radius.circular(12)).w,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
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
              child: Padding(
                padding: EdgeInsets.only(top: 60.h),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600.h,
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 40.h, horizontal: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/head.png',
                                    ),
                                    height: 300.h,
                                    width: 300.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Text(
                                  'Welcome to Magic Mirror!',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  'Magic Mirror purpose is resolving unresolved issues of the past, by associating (traumatic) memories to diverse sensations',
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 40.h, horizontal: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/patient.png',
                                    ),
                                    height: 300.h,
                                    width: 300.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Text(
                                  'This is purely private experience',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  'You are offered the tool for which you alone are solely responsible in its use: their life is their response-ability.',
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 40.h, horizontal: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/head2.png',
                                    ),
                                    height: 300.h,
                                    width: 300.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Text(
                                  'You will focus on a specific memory',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  'With the purpose of being able to connect a blocked part of their mind to functional parts of their mind.',
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 40.h, horizontal: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/procedure.png',
                                    ),
                                    height: 300.h,
                                    width: 600.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Text(
                                  'Get the bests results!',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  'The procedure which you are invited to follow needs to be completed in the same way as a cooking recipe',
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 40.h, horizontal: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/thumbsup.png',
                                    ),
                                    height: 300.h,
                                    width: 300.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Text(
                                  'We need your consent',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  'We remind that you take full responsibility of the entire process and its outcome, and that they know that the tool has been designed to help them with our life; not to harm them.',
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 40.h, horizontal: 40.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/memories.png',
                                    ),
                                    height: 300.h,
                                    width: 300.w,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Text(
                                  'You are learning to edit your memories',
                                  style: kTitleStyle,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  'Those are their own memories, that they created/experienced those memories in the past, and take full responsibility to heal those memories in the present.',
                                  style: kSubtitleStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30.0.w,
                          ),
                          SizedBox(width: 10.h),
                          Text(
                            'Previous',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(width: 140.w),
                  if (_currentPage < _numPages - 1)
                    TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30.0.w,
                          ),
                          SizedBox(width: 9.25.w),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0).w,
                              ),
                              backgroundColor: Color.fromARGB(255, 8, 54, 85),
                              title: Text(
                                'Disclaimer',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                'The software is provided as-is and the user alone is responsible for its use and consequences. No others are liable. This is free open source software.',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacementNamed(
                                        LoginScreen.routeName);
                                  },
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Let\'s start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                        ),
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
