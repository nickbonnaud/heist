import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'page_offset_notifier.dart';


class PageIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  key: Key("loginIndicatorKey"),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() == 0 
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSecondarySubdued
                  ),
                  height: 6.h,
                  width: 6.w,
                ),
                SizedBox(width: 8.w),
                Container(
                  key: Key("registerIndicatorKey"),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() != 0 
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSecondarySubdued
                  ),
                  height: 6.h,
                  width: 6.w,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}