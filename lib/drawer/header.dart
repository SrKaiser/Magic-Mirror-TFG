import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ad_units_outlined,
            size: 30.w,
            color: Colors.white,
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 3,
            child: Text(
              'Magic Mirror',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
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
