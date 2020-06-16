import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/permission_screen/bloc/permission_screen_bloc.dart';

import 'permission_buttons/bloc/permission_buttons_bloc.dart';
import 'permission_buttons/permission_buttons.dart';

class LocationBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  LocationBody({@required PermissionButtons permissionButtons})
    : assert(permissionButtons != null),
      _permissionButtons = permissionButtons;

  final String locationTextIos = 
    "Please set Location Services to 'While in Use'.\n\n"
    "${Constants.appName} uses Location Services only when paying for transactions for security purposes.";
  
  final String locationTextAndroid = 
    'Location Services are required to use ${Constants.appName}.\n\n'
    'This enables ${Constants.appName} to be detected by beacons.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PlatformText(
          'Location Services',
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
          "assets/slide_1.png",
          fit: BoxFit.contain,
          height: 350,
        ),
        SizedBox(height: 25.0),
        PlatformWidget(
          ios: (_) => PlatformText(locationTextIos,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          android: (_) => PlatformText(locationTextAndroid,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 28,
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ),
        SizedBox(height: 35),
        BlocProvider<PermissionButtonsBloc>(
          create: (_) => PermissionButtonsBloc(),
          child: _permissionButtons
        )
      ],
    );
  }
}