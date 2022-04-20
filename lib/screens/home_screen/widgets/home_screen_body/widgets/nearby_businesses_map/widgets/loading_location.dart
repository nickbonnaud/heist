import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingLocation extends StatelessWidget {
  
  const LoadingLocation({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
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
          const CircularProgressIndicator(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}