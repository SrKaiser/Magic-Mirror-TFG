import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String> getImageUrl(String imagePath) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child(imagePath);

  String imageUrl = await ref.getDownloadURL();
  return imageUrl;
}

Future<List<Map<String, dynamic>>> getAssociations() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('associations');
  DataSnapshot snapshot = await ref.get();
  Map<String, dynamic> data = snapshot.value;
  List<Map<String, dynamic>> associations = [];

  data.forEach((key, value) {
    Map<String, dynamic> association = value;
    association['key'] = key;
    associations.add(association);
  });

  return associations;
}

class AssociationsGrid extends StatefulWidget {
  @override
  _AssociationsGridState createState() => _AssociationsGridState();
}

class _AssociationsGridState extends State<AssociationsGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAssociations(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: FutureBuilder(
                    future: getImageUrl(
                        'associations/${snapshot.data[index]['id']}/icon.png'),
                    builder: (context, AsyncSnapshot<String> imageUrlSnapshot) {
                      if (imageUrlSnapshot.connectionState ==
                              ConnectionState.done &&
                          imageUrlSnapshot.hasData) {
                        return Image.network(
                          imageUrlSnapshot.data,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No associations found.'));
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
