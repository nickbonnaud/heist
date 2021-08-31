import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../permission_buttons/bloc/permission_buttons_bloc.dart';
import '../../permission_buttons/permission_buttons.dart';
import 'widgets/title_text.dart';

class BluetoothBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  BluetoothBody({required PermissionButtons permissionButtons})
    : _permissionButtons = permissionButtons;

  final String bluetoothText = 
  'Bluetooth is a core part of ${Constants.appName}.\n\n'
  'This enables ${Constants.appName} to interact with Bluetooth Beacons.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 15.h),
            TitleText(text: 'Bluetooth'),
            SizedBox(height: 50.h),
            Text('Stage 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
            ),
            Text(bluetoothText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimarySubdued,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold
              ),
            )
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