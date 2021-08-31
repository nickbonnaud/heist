import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Fetching Current Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.sp
              ),
            )
          ),
          SizedBox(height: 15.h),
          CircularProgressIndicator(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}