import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 35.sp,
          height: 35.sp,
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}