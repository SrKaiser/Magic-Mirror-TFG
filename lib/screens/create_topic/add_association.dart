import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAssociation extends StatelessWidget {
  const AddAssociation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0).r,
        side: BorderSide(color: Colors.black, width: 2.0.w),
      ),
      buttonSize: Size(48.0.w, 48.h),
      childrenButtonSize: Size(110.0.w, 48.h),
      children: [
        SpeedDialChild(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0).r,
            side: BorderSide(color: Colors.black, width: 1.0.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Trees',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 5.w,
              ),
              Icon(Icons.terrain_rounded),
            ],
          ),
          onTap: () {},
        ),
        SpeedDialChild(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0).r,
            side: BorderSide(color: Colors.black, width: 1.0.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Animals',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 5.w,
              ),
              Icon(Icons.cruelty_free_outlined),
            ],
          ),
          onTap: () {},
        ),
      ],
      child: Icon(
        Icons.add,
        color: Colors.black,
        size: 30.w,
      ),
    );
  }
}
