import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/resources/constants.dart';

class NoNearbyLocations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlatformText(
            'No Nearby Businesses',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24,
                fontWeight: FontWeight.bold
              )
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Image.asset(
            "assets/slide_1.png",
            fit: BoxFit.contain,
            height: 250,
          ),
          SizedBox(height: 15.0),
          PlatformText(
            '${Constants.appName} is not operating in this area.',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
             textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}