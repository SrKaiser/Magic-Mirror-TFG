import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/topic.dart';
import '../create_topic/add_topic.dart';
import '../topics_panel/topic_item.dart';
import '../../utilities/loading_spinner.dart';

class TopicsList extends StatefulWidget {
  final filterSelected;
  TopicsList(this.filterSelected);

  @override
  State<TopicsList> createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList> {
  Query dbRef;
  List<Topic> topics = [];
  @override
  void initState() {
    // User user = FirebaseAuth.instance.currentUser;
    // dbRef = FirebaseDatabase.instance
    //     .ref()
    //     .child("users")
    //     .child(user.uid)
    //     .child("topics");
    print(widget.filterSelected);
    User user = FirebaseAuth.instance.currentUser;
    var myTopicsStorage = TopicsStorage(user.uid);
    myTopicsStorage.loadTopicsByFilter(widget.filterSelected).then(
      (loadedTopics) {
        setState(() {
          topics = loadedTopics;
        });
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TopicsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    User user = FirebaseAuth.instance.currentUser;
    var myTopicsStorage = TopicsStorage(user.uid);
    myTopicsStorage.loadTopicsByFilter(widget.filterSelected).then(
      (loadedTopics) {
        setState(() {
          topics = loadedTopics;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: topics.length > 0
          ? ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return TopicItem(
                  topic: topics[index],
                );
              },
            )
          // Column(
          //     children: topics.map((topic) => TopicItem(topic)).toList(),
          //   )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingSpinner(),
                  SizedBox(
                    height: 20.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AddTopicScreen.routeName);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 32, 53, 130),
                      ),
                      fixedSize: MaterialStateProperty.all(Size(350.w, 50.h)),
                    ),
                    child: Text(
                      'Add your first topic here',
                      style: TextStyle(color: Colors.white, fontSize: 26.0.sp),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: double.infinity,
  //     child: StreamBuilder(
  //       stream: dbRef.onValue,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData && snapshot.data.snapshot.value != null) {
  //           return FirebaseAnimatedList(
  //             query: dbRef,
  //             itemBuilder: (context, snapshot, animation, index) {
  //               Map topic = snapshot.value as Map;
  //               topic['key'] = topic.keys;
  //               return TopicItem(topic);
  //             },
  //           );
  //         } else {
  // return Center(
  //     child: Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: [
  //     // Text(
  //     //   'Waiting the first topic to be added...',
  //     //   textAlign: TextAlign.center,
  //     //   style: TextStyle(
  //     //     fontSize: 26.sp,
  //     //     fontWeight: FontWeight.bold,
  //     //   ),
  //     // ),
  //     SizedBox(
  //       height: 20.h,
  //     ),
  //     LoadingSpinner(),
  //   ],
  // ));
  //         }
  //       },
  //     ),
  //   );
  // }

}
