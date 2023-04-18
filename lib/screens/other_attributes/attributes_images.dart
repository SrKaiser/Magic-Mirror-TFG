import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/topic.dart';

Future<String> getImageUrl(String id) async {
  final ref = FirebaseStorage.instance.ref('associations/' + id);
  final url = await ref.getDownloadURL();
  return url;
}

Future<List<Widget>> getOtherAttributes(Topic topic) async {
  List<Widget> attributesImages = [];
  if (topic.animalsAttribute != null) {
    final imageUrl = await getImageUrl('animals/${topic.animalsAttribute}.png');
    attributesImages.add(
      Container(
        height: 90.h,
        width: 90.w,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  if (topic.smellsAttribute != null) {
    attributesImages.add(Text('Smell: ${topic.smellsAttribute}'));
  }
  if (topic.flavourAttribute != null) {
    attributesImages.add(Text('Flavour: ${topic.flavourAttribute}'));
  }
  if (topic.soundsAttribute != null) {
    attributesImages.add(Text('Sound: ${topic.soundsAttribute}'));
  }
  if (topic.texturesAttribute != null) {
    attributesImages.add(Text('Texture: ${topic.texturesAttribute}'));
  }
  if (topic.treesAttribute != null) {
    attributesImages.add(Text('Tree: ${topic.treesAttribute}'));
  }

  return attributesImages;
}

class AttributesImages extends StatefulWidget {
  final Topic topic;
  AttributesImages(this.topic);
  @override
  State<AttributesImages> createState() => _AttributesImagesState();
}

class _AttributesImagesState extends State<AttributesImages> {
  Future<List<Widget>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = getOtherAttributes(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _imagesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: snapshot.data,
          );
        }
      },
    );
  }
}
