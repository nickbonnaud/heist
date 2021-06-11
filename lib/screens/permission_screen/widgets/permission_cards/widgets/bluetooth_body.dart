import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

import '../../permission_buttons/bloc/permission_buttons_bloc.dart';
import '../../permission_buttons/permission_buttons.dart';

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
            SizedBox(height: SizeConfig.getHeight(2)),
            VeryBoldText2(text: 'Bluetooth', context: context),
            SizedBox(height: SizeConfig.getHeight(6)),
            PlatformText('Stage 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: SizeConfig.getWidth(6),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
            ),
            PlatformText(bluetoothText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimarySubdued,
                fontSize: SizeConfig.getWidth(6),
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