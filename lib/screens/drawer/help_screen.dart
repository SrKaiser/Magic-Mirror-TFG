import 'package:flutter/material.dart';
import '../../drawer/drawer.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
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
        ],
      ),
    );
  }
}
