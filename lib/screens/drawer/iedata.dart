import 'package:flutter/material.dart';
import '../../drawer/drawer.dart';

class ImportExportScreen extends StatelessWidget {
  static const routeName = '/import-export-data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import/Export Data'),
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
