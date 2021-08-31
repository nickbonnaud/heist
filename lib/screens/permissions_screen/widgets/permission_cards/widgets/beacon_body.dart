import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/permissions_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../permission_buttons/permission_buttons.dart';
import 'widgets/title_text.dart';

class BeaconBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  BeaconBody({required PermissionButtons permissionButtons})
    : _permissionButtons = permissionButtons;

  final String beaconText = 
  'Beacons ensure that you are in the correct Business.\n\n'
  "Beacon Settings are a part of Location Services.\n\n"
  "Press Enable > Select 'Location' > Change to 'Always'.";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 15.h),
            TitleText(text: 'Beacons'),
            SizedBox(height: 50.h),
            Text('Stage 4',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
            ),
           Text(beaconText,
              textAlign: TextAlign.center,
              style:TextStyle(
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
        ),
      ],
    );
  }
}