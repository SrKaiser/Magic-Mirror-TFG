import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/topic.dart';
import '/screens/other_attributes/association_widget.dart';

Future<String> getImageUrl(String id) async {
  final ref = FirebaseStorage.instance.ref('associations/' + id + '/icon.png');
  final url = await ref.getDownloadURL();
  return url;
}

Future<List<Widget>> buildContainers(BuildContext contextApp, Topic topic,
    Function(Topic) onTopicUpdated, bool topicCreation) async {
  final snapshot =
      await FirebaseDatabase.instance.ref().child('associations').once();
  List<Widget> containers = [];

  Map<dynamic, dynamic> associations = snapshot.snapshot.value;

  for (var key in associations.keys) {
    final imageUrl = await getImageUrl(key);
    containers.add(
      GestureDetector(
        onTap: () {
          Navigator.of(contextApp)
              .pushNamed(AssociationWidgetScreen.routeName, arguments: {
            'topic': topic,
            'attribute': key,
            'creation': topicCreation,
          }).then((value) {
            if (topicCreation == true) {
              onTopicUpdated(value);
            }
          });
        },
        child: Container(
          height: 92.h,
          width: 92.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0).r,
            border: Border.all(color: Colors.black, width: 2.w),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Text(key),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  return containers;
}

class AssociationsGrid extends StatefulWidget {
  final BuildContext contextApp;
  final Topic topic;
  final Function(Topic) onTopicUpdated;
  final bool topicCreation;

  AssociationsGrid(
      {this.contextApp, this.topic, this.onTopicUpdated, this.topicCreation});

  @override
  _AssociationsGridState createState() => _AssociationsGridState();
}

class _AssociationsGridState extends State<AssociationsGrid> {
  Future<List<Widget>> _containersFuture;

  @override
  void initState() {
    super.initState();
    _containersFuture = buildContainers(widget.contextApp, widget.topic,
        widget.onTopicUpdated, widget.topicCreation);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _containersFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Wrap(
            spacing: 22.0.w,
            runSpacing: 16.0.h,
            children: snapshot.data,
          );
        }
      },
    );
  }
}
