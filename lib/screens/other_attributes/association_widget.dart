import 'package:flutter/material.dart';
import 'package:magic_mirror/models/topic.dart';

class AssociationWidgetScreen extends StatefulWidget {
  static const routeName = '/association-widget';

  @override
  State<AssociationWidgetScreen> createState() =>
      _AssociationWidgetScreenState();
}

class _AssociationWidgetScreenState extends State<AssociationWidgetScreen> {
  Color colorAssociated;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final Topic topic = args['topic'];
    final String attribute = args['attribute'];
    colorAssociated = Color(int.parse(topic.colorAssociated.substring(6, 16)));
    return Scaffold(
      backgroundColor: colorAssociated,
      appBar: AppBar(
        title: Text('Attribute: ' +
            attribute.replaceFirst(attribute[0], attribute[0].toUpperCase())),
        backgroundColor:
            HSLColor.fromColor(colorAssociated).withLightness(0.1).toColor(),
      ),
    );
  }
}
