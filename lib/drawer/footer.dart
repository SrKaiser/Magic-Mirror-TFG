import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../screens/auth_process/login_screen.dart';
import '../screens/drawer/settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDrawerFooter extends StatefulWidget {
  @override
  State<AppDrawerFooter> createState() => _AppDrawerFooterState();
}

class _AppDrawerFooterState extends State<AppDrawerFooter> {
  String imageUrl;
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0).w,
            ),
            backgroundColor: Color.fromARGB(255, 32, 53, 130),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Successful logout",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Image image;
  Future<String> downloadPhoto() async {
    User user = FirebaseAuth.instance.currentUser;
    String url = await FirebaseStorage.instance
        .ref('${user.uid}/profile_photo.jpg')
        .getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(SettingsScreen.routeName);
      },
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: FutureBuilder(
                      future: downloadPhoto(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.network(
                            snapshot.data,
                            fit: BoxFit.cover,
                          );
                        } else
                          return null;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          FirebaseAuth.instance.currentUser.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Patient',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
