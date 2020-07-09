import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/permission_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'help_video.dart';
import 'permission_buttons/permission_buttons.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        VeryBoldText2(text: 'Beacons', context: context),
        SizedBox(height: SizeConfig.getHeight(6)),
        Image.asset(
          "assets/slide_3.png",
          fit: BoxFit.contain
        ),
        SizedBox(height: SizeConfig.getHeight(6)),
        PlatformText(beaconText,
          textAlign: TextAlign.center,
          style:TextStyle(
            color: Theme.of(context).colorScheme.textOnLightSubdued,
            fontSize: SizeConfig.getWidth(5),
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(1)),
        FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: BoldText4(text: 'How?', context: context, color: Theme.of(context).colorScheme.secondary),
          onPressed: () => _showHowModal(context),
        ),
        SizedBox(height: SizeConfig.getHeight(8)),
        BlocProvider<PermissionButtonsBloc>(
          create: (_) => PermissionButtonsBloc(),
          child: _permissionButtons
        )
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