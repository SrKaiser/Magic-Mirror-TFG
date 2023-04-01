import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stress_record_app/models/topic.dart';
import 'package:stress_record_app/screens/create_topic/associations.dart';
import '../../utilities/styles.dart';

class CautionScreen extends StatefulWidget {
  static const routeName = '/caution';
  @override
  State<CautionScreen> createState() => _CautionScreenState();
}

class _CautionScreenState extends State<CautionScreen> {
  final int _numPages = 4;
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
    var newTopic = ModalRoute.of(context).settings.arguments as Topic;
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              AssociationsScreen.routeName,
                              arguments: newTopic);
                        },
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
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Do the following process while you are uninterrupted.\n\n'
                                    'Please disconnect your telephone, tell people around you to leave you undisturbed.\n\n'
                                    'Please focus on your task at hand.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23.0.sp,
                                      height: 1.4.h,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Remember: you will look into memories which perhaps you previously ignored, or could not resolve.\n\n'
                                    'By reactivating memories they become alive.\n\n'
                                    'Observe them realise that they are in the past. Not now, not here.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23.0.sp,
                                      height: 1.4.h,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'While you feel into this memory, please focus on your breathing - it reminds me that these are your memories.\n\n'
                                    'They must not control you. If they do not serve you: change them.\n\n'
                                    'In order to change them, you must first be able to see them for what they are: memories. Of experiences. Of the past.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23.0.sp,
                                      height: 1.4.h,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'If you get caught up in the past, and slow down in this process, a bell will sound to call you back to the present\n\n'
                                    'In selecting the associations for your memory, intuitively choose the symbol which first calls your attention',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23.0.sp,
                                      height: 1.4.h,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
                        Navigator.of(context).pushReplacementNamed(
                            AssociationsScreen.routeName,
                            arguments: newTopic);
                      },
                      child: Text(
                        'I\'m ready',
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
