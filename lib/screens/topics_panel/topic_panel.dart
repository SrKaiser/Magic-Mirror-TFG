import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../create_topic/add_topic.dart';
import 'topics_list.dart';
import '../../drawer/drawer.dart';

class TopicPanelScreen extends StatefulWidget {
  static const routeName = '/main-patient';

  @override
  State<TopicPanelScreen> createState() => _TopicPanelScreenState();
}

class _TopicPanelScreenState extends State<TopicPanelScreen> {
  List<PopupMenuItem<String>> opciones = [
    PopupMenuItem(
      value: 'stress',
      child: Column(
        children: [
          Text(
            'Stress Level',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'dateOccurrence',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Date of occurrence',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'dateAdded',
      child: Column(
        children: [
          Text(
            'Date added',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
        ],
      ),
    ),
  ];

  String _filterSelected;
  @override
  void initState() {
    _loadLastFilter();
    super.initState();
  }

  void _loadLastFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _filterSelected = prefs.getString('lastFilter') ?? 'defaultFilter';
    });
  }

  void _saveLastFilter(String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastFilter', filter);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Topics Panel'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
              ),
              onPressed: () async {
                String seleccion = await showMenu(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                  color: Color.fromARGB(255, 32, 53, 130),
                  context: context,
                  position: RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
                  items: opciones,
                  elevation: 8.0,
                );
                setState(() {
                  _filterSelected = seleccion;
                });
                _saveLastFilter(_filterSelected);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddTopicScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Stack(
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
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: 740.h, child: TopicsList(_filterSelected)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
