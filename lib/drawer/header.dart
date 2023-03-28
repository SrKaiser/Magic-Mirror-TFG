import 'package:flutter/material.dart';

class AppDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ad_units_outlined,
            size: 30,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              'Magic Mirror',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
