// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:magic_mirror/models/topic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/screens/edit_topic/edit_topic.dart';

Future<List<Widget>> buildTiles(
    String attribute, Color colorAssociated, Topic topic, bool creation) async {
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child('associations')
      .child(attribute)
      .child('categories')
      .once();
  Map<dynamic, dynamic> categories = snapshot.snapshot.value;
  List<Widget> tiles = [];

  for (var key in categories.keys) {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('associations')
        .child(attribute)
        .child('categories')
        .child(key.toString())
        .once();
    Map<dynamic, dynamic> subcategories = snapshot.snapshot.value;
    List<String> subcats = [];
    for (var subcat in subcategories.keys) {
      subcats.add(subcat.replaceFirst(subcat[0], subcat[0].toUpperCase()));
    }

    tiles.add(DropdownBar(
      title: key.replaceFirst(key[0], key[0].toUpperCase()),
      dropdownItems: subcats,
      barColor: colorAssociated,
      topic: topic,
      creation: creation,
    ));
  }

  return tiles;
}

class AssociationWidgetScreen extends StatefulWidget {
  static const routeName = '/association-widget';

  @override
  State<AssociationWidgetScreen> createState() =>
      _AssociationWidgetScreenState();
}

class _AssociationWidgetScreenState extends State<AssociationWidgetScreen> {
  Color colorAssociated;
  Future<List<Widget>> _tilesFuture;
  bool _initialized = false;

  void getTiles(
      String attribute, Color colorAssociated, Topic topic, bool creation) {
    setState(() {
      _tilesFuture = buildTiles(attribute, colorAssociated, topic, creation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final Topic topic = args['topic'];
    final String attribute = args['attribute'];
    final bool creation = args['creation'];
    colorAssociated = Color(int.parse(topic.colorAssociated.substring(6, 16)));
    if (_initialized == false) {
      _initialized = true;
      getTiles(attribute, colorAssociated, topic, creation);
    }
    return Scaffold(
      backgroundColor: colorAssociated,
      appBar: AppBar(
        title: Text('Attribute: ' +
            attribute.replaceFirst(attribute[0], attribute[0].toUpperCase())),
        backgroundColor:
            HSLColor.fromColor(colorAssociated).withLightness(0.1).toColor(),
      ),
      body: FutureBuilder<List<Widget>>(
        future: _tilesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data,
              ),
            );
          }
        },
      ),
    );
  }
}

class DropdownBar extends StatefulWidget {
  final String title;
  final List<String> dropdownItems;
  final Color barColor;
  Topic topic;
  bool creation;

  DropdownBar({
    this.title,
    this.dropdownItems,
    this.barColor,
    this.topic,
    this.creation,
  });

  @override
  _DropdownBarState createState() => _DropdownBarState();
}

class _DropdownBarState extends State<DropdownBar> {
  bool isDropdownOpen = false;
  double dropdownHeight = 0;

  void toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
      dropdownHeight = isDropdownOpen ? widget.dropdownItems.length * 55.0 : 0;
    });
  }

  void submit(Topic newTopic, String elementSelected, bool creation) async {
    newTopic.animalsAttribute = elementSelected.replaceFirst(
        elementSelected[0], elementSelected[0].toLowerCase());
    User user = FirebaseAuth.instance.currentUser;
    var myTopicsStorage = TopicsStorage(user.uid);
    await myTopicsStorage.saveTopic(newTopic);
    if (creation == false) {
      Navigator.of(context)
          .pushReplacementNamed(EditTopicScreen.routeName, arguments: newTopic);
    } else {
      Navigator.of(context).pop(newTopic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: HSLColor.fromColor(widget.barColor)
                  .withLightness(0.2)
                  .toColor(),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isDropdownOpen
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                  ),
                  onPressed: toggleDropdown,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          height: dropdownHeight.h,
          duration: Duration(milliseconds: 200),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.dropdownItems.length,
            itemBuilder: (context, index) {
              return Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: HSLColor.fromColor(widget.barColor)
                      .withLightness(0.4)
                      .toColor(),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.w,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    widget.dropdownItems[index],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.sp),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    String elementSelected = widget.dropdownItems[index];
                    submit(widget.topic, elementSelected, widget.creation);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
