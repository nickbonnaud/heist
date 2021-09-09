import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../permission_buttons/bloc/permission_buttons_bloc.dart';
import '../../permission_buttons/permission_buttons.dart';
import 'widgets/title_text.dart';

class LocationBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  LocationBody({required PermissionButtons permissionButtons})
    : _permissionButtons = permissionButtons;

  final String locationTextIos = 
    "Please set Location Services to 'While in Use'.\n\n"
    "${Constants.appName} uses Location Services to load nearby locations and for security purposes.";
  
  final String locationTextAndroid = 
    'Location Services enable ${Constants.appName} to be detected by beacons.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 15.h),
            TitleText(text: 'Stage: Location Services'),
            SizedBox(height: 25.h),
            PlatformWidget(
              cupertino: (_, __) => Text(locationTextIos,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold
                )
              ),
              material: (_, __) => Text(locationTextAndroid,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold
                )
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