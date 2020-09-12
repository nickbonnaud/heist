import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/permission_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'help_video.dart';
import '../../permission_buttons/permission_buttons.dart';

class BeaconBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  BeaconBody({@required PermissionButtons permissionButtons})
    : assert(permissionButtons != null),
      _permissionButtons = permissionButtons;

  final String beaconText = 
  'Beacons enable ${Constants.appName} to know when you enter and leave a business.\n\n'
  "Beacon Settings are a part of Location Services, please change from 'While Using the App' to 'Always'.";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VeryBoldText2(text: 'Beacons', context: context),
                IconButton(
                  iconSize: SizeConfig.getWidth(6),
                  icon: Icon(Icons.help), 
                  onPressed: () => _showHowModal(context),
                )
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(1)),
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
            SizedBox(height: SizeConfig.getHeight(1)),
          ],
        ),
        BlocProvider<PermissionButtonsBloc>(
          create: (_) => PermissionButtonsBloc(),
          child: _permissionButtons
        ),
      ],
    );
  }

  void _showHowModal(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        content: HelpVideo(),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Close'),
            onPressed: () => Navigator.pop(context)
          )
        ],
        
      )
    );
  }
}