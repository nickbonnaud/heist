import 'package:flutter/material.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/title_text.dart';

class SuccessCard extends StatelessWidget {

  final String successText =
  'All permissions are ready. Start using ${Constants.appName} now!';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), 
            spreadRadius: 1.0,
            blurRadius: 5,
            offset: Offset(0, -5.h)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 15.h),
              TitleText(text: 'Success'),
              SizedBox(height: 50.h),
              Text('Permissions are a Go!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline
                ),
              ),
              SizedBox(height: 20.h),
              Text(successText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimarySubdued,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold
                  ),
              )
            ],
          ),
          Container()
        ],
      ),
    );
  }
}