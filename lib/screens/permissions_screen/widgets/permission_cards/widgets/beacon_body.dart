import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/permissions_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../permission_buttons/permission_buttons.dart';
import 'widgets/title_text.dart';

class BeaconBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  const BeaconBody({required PermissionButtons permissionButtons, Key? key})
    : _permissionButtons = permissionButtons,
      super(key: key);

  final String beaconIosText = 
    "Beacon Settings are a part of Location Services.\n"
    "Press Enable > Select 'Location' > Change to 'Always'.";

  final String beaconAndroidText = 
    "Beacon Settings are a part of Location Services.\n"
    "Press Enable > Change to 'Allow all the time'.";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 15.h),
            const TitleText(text: 'Stage: Beacons'),
            SizedBox(height: 25.h),
            Text(
              Platform.isIOS
                ? beaconIosText
                : beaconAndroidText,
              textAlign: TextAlign.center,
              style:TextStyle(
                color: Theme.of(context).colorScheme.onPrimarySubdued,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        BlocProvider<PermissionButtonsBloc>(
          create: (_) => PermissionButtonsBloc(),
          child: _permissionButtons
        ),
      ],
    );
  }
}