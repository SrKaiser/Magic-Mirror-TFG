import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:magic_mirror/models/topic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<List<Widget>> buildTiles(String attribute, Color colorAssociated) async {
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child('associations')
      .child(attribute)
      .child('categories')
      .once();
  List<Widget> tiles = [];

  Map<dynamic, dynamic> associations = snapshot.snapshot.value;

  for (var key in associations.keys) {
    tiles.add(DropdownBar(
      title: key.replaceFirst(key[0], key[0].toUpperCase()),
      dropdownItems: ['a', 'b'],
      barColor: colorAssociated,
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

  void getTiles(String attribute, Color colorAssociated) {
    setState(() {
      _tilesFuture = buildTiles(attribute, colorAssociated);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final Topic topic = args['topic'];
    final String attribute = args['attribute'];
    colorAssociated = Color(int.parse(topic.colorAssociated.substring(6, 16)));
    if (_initialized == false) {
      _initialized = true;
      getTiles(attribute, colorAssociated);
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

  DropdownBar({this.title, this.dropdownItems, this.barColor});

  @override
  _DropdownBarState createState() => _DropdownBarState();
}

class _DropdownBarState extends State<DropdownBar> {
  bool isDropdownOpen = false;
  double dropdownHeight = 0;

  void toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
      dropdownHeight = isDropdownOpen
          ? 200
          : 0; // Ajusta la altura del contenedor de la lista desplegable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            height: 50,
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
                        fontSize: 20,
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
          height: dropdownHeight,
          duration: Duration(milliseconds: 200),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.dropdownItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.dropdownItems[index]),
                onTap: () {
                  print('Seleccionado: ${widget.dropdownItems[index]}');
                  toggleDropdown();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
