import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

import '../../permission_buttons/bloc/permission_buttons_bloc.dart';
import '../../permission_buttons/permission_buttons.dart';

class LocationBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  LocationBody({@required PermissionButtons permissionButtons})
    : assert(permissionButtons != null),
      _permissionButtons = permissionButtons;

  final String locationTextIos = 
    "Please set Location Services to 'While in Use'.\n\n"
    "${Constants.appName} uses Location Services to load nearby locations and for security purposes.";
  
  final String locationTextAndroid = 
    'Location Services are required to use ${Constants.appName}.\n\n'
    'This enables ${Constants.appName} to be detected by beacons.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: SizeConfig.getHeight(1)),
            VeryBoldText2(text: 'Location Services', context: context),
            SizedBox(height: SizeConfig.getHeight(6)),
            PlatformText('Stage 3',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: SizeConfig.getWidth(6),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
            ),
            PlatformWidget(
              ios: (_) => PlatformText(locationTextIos,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: SizeConfig.getWidth(6),
                  fontWeight: FontWeight.bold
                )
              ),
              android: (_) => PlatformText(locationTextAndroid,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: SizeConfig.getWidth(6),
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