import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/permission_screen/bloc/permission_screen_bloc.dart';
import 'package:heist/screens/permission_screen/widgets/permission_buttons/bloc/permission_buttons_bloc.dart';

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
        PlatformText(
          'Beacons',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 34,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        SizedBox(height: 25.0),
        Image.asset(
          "assets/slide_3.png",
          fit: BoxFit.contain,
          height: 350,
        ),
        SizedBox(height: 25.0),
        PlatformText(beaconText,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        PlatformButton(
          child: PlatformText('How?'),
          onPressed: () => _showHowModal(context),
        ),
        SizedBox(height: 35),
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