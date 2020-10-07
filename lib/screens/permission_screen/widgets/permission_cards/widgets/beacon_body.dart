import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/permission_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import '../../permission_buttons/permission_buttons.dart';

class BeaconBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  BeaconBody({@required PermissionButtons permissionButtons})
    : assert(permissionButtons != null),
      _permissionButtons = permissionButtons;

  final String beaconText = 
  'Beacons ensure that you are in the correct Business.\n\n'
  "Beacon Settings are a part of Location Services.\n\n"
  "Press Enable > Select 'Location' > Change to 'Always'.";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            VeryBoldText2(text: 'Beacons', context: context),
            SizedBox(height: SizeConfig.getHeight(6)),
            PlatformText('Stage 4',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: SizeConfig.getWidth(6),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
            ),
            PlatformText(beaconText,
              textAlign: TextAlign.center,
              style:TextStyle(
                color: Theme.of(context).colorScheme.onPrimarySubdued,
                fontSize: SizeConfig.getWidth(6),
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