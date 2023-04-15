import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magic_mirror/models/topic.dart';
import 'package:magic_mirror/screens/other_attributes/association_widget.dart';

Future<String> getImageUrl(String id) async {
  print(id);
  final ref = FirebaseStorage.instance.ref('associations/' + id + '/icon.png');
  final url = await ref.getDownloadURL();
  return url;
}

Future<List<Widget>> buildContainers(
    BuildContext contextApp, Topic topic) async {
  final snapshot =
      await FirebaseDatabase.instance.ref().child('associations').once();
  List<Widget> containers = [];

  Map<dynamic, dynamic> associations = snapshot.snapshot.value;

  for (var key in associations.keys) {
    final imageUrl = await getImageUrl(key);
    containers.add(
      GestureDetector(
        onTap: () {
          print(key);
          Navigator.of(contextApp).pushNamed(AssociationWidgetScreen.routeName,
              arguments: {'topic': topic, 'attribute': key});
        },
        child: Container(
          height: 92.h,
          width: 92.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 5),
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Text(key),
              SizedBox(height: 5),
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
  AssociationsGrid(this.contextApp, this.topic);
  @override
  _AssociationsGridState createState() => _AssociationsGridState();
}

class _AssociationsGridState extends State<AssociationsGrid> {
  Future<List<Widget>> _containersFuture;

  @override
  void initState() {
    super.initState();
    _containersFuture = buildContainers(widget.contextApp, widget.topic);
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
            spacing: 22.0,
            runSpacing: 16.0,
            children: snapshot.data,
          );
        }
      },
    );
  }
}
