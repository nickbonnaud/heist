import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../permission_buttons/bloc/permission_buttons_bloc.dart';
import '../../permission_buttons/permission_buttons.dart';
import 'widgets/title_text.dart';


class NotificationBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  NotificationBody({required PermissionButtons permissionButtons})
    : _permissionButtons = permissionButtons;

  final String notificationText = 
  'Notifications are required to receive and pay for transactions.';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 15.h),
            TitleText(text: 'Stage: Notifications'),
            SizedBox(height: 25.h),
            Text(notificationText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimarySubdued,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        BlocProvider<PermissionButtonsBloc>(
          create: (_) => PermissionButtonsBloc(),
          child: _permissionButtons
        )
      ],
    );
  }
}