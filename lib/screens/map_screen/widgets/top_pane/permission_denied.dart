import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class PermissionDenied extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlatformText(
            'Location Services not Granted',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Image.asset(
            "assets/slide_3.png",
            fit: BoxFit.contain,
            height: 250,
          ),
          SizedBox(height: 15.0),
          PlatformText(
            'Unable to fetch nearby Businesses because Location Services are not Granted.',
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
      )
    );
  }
}