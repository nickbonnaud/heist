import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/permission_screen/bloc/permission_screen_bloc.dart';

import 'permission_buttons.dart';

class BluetoothBody extends StatelessWidget {
  final AnimationController _controller;
  
  BluetoothBody({@required controller})
    : assert(controller != null),
      _controller = controller;

  final String bluetoothText = 
  'Bluetooth is a core part of ${Constants.appName}.\n\n'
  'This enables ${Constants.appName} to interact with Bluetooth Beacons.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PlatformText(
          'Bluetooth',
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
        PlatformText(bluetoothText,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        SizedBox(height: 35),
        PermissionButtons(permission: PermissionType.bluetooth, controller: _controller,)
      ],
    );
  }
}