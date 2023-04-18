import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './navobserver.dart';
import './screens/auth_process/forgotpass_screen.dart';
import './screens/create_topic/caution.dart';
import './screens/drawer/iedata.dart';
import './screens/edit_topic/edit_body.dart';
import './screens/edit_topic/edit_color.dart';
import './screens/edit_topic/edit_information.dart';
import './screens/edit_topic/edit_stress_level.dart';
import './screens/edit_topic/edit_topic.dart';
import './screens/create_topic/association_shape.dart';
import './screens/create_topic/association_body_region.dart';
import './screens/create_topic/association_color.dart';
import './screens/create_topic/associations.dart';
import './screens/create_topic/add_topic.dart';
import './screens/create_topic/charge_level.dart';
import './screens/drawer/help_screen.dart';
import './screens/topics_panel/topic_panel.dart';
import './screens/drawer/settings_screen.dart';
import './screens/auth_process/signup_screen.dart';
import './screens/auth_process/login_screen.dart';
import './screens/auth_process/welcome_screen.dart';
import './screens/other_attributes/association_widget.dart';
import './utilities/router_observer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showWelcomeScreen = true;

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    setState(() {
      _showWelcomeScreen = !_seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 830),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Magic Mirror',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Color.fromARGB(255, 32, 53, 130),
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 24.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyText1: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.white,
            ),
          ),
        ),
        navigatorObservers: [MyNavigatorObserver(), routeObserver],
        home: _showWelcomeScreen
            ? WelcomeScreen()
            : StreamBuilder<User>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return TopicPanelScreen();
                  } else {
                    return LoginScreen();
                  }
                },
              ),
        routes: {
          WelcomeScreen.routeName: (context) => WelcomeScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          TopicPanelScreen.routeName: (context) => TopicPanelScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          HelpScreen.routeName: (context) => HelpScreen(),
          AddTopicScreen.routeName: (context) => AddTopicScreen(),
          ChargeLevelScreen.routeName: (context) => ChargeLevelScreen(),
          AssociationsScreen.routeName: (context) => AssociationsScreen(),
          AssociationColorScreen.routeName: (context) =>
              AssociationColorScreen(),
          AssociationBodyScreen.routeName: (context) => AssociationBodyScreen(),
          AssociationShapeScreen.routeName: (context) =>
              AssociationShapeScreen(),
          EditTopicScreen.routeName: (context) => EditTopicScreen(),
          EditInformationScreen.routeName: (context) => EditInformationScreen(),
          EditStressScreen.routeName: (context) => EditStressScreen(),
          EditColorScreen.routeName: (context) => EditColorScreen(),
          EditBodyScreen.routeName: (context) => EditBodyScreen(),
          ImportExportScreen.routeName: (context) => ImportExportScreen(),
          CautionScreen.routeName: (context) => CautionScreen(),
          AssociationWidgetScreen.routeName: (context) =>
              AssociationWidgetScreen(),
        },
      ),
    );
  }
}
