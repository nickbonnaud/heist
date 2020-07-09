import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class PermissionDenied extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: BoldText3(text: 'Location Services not Granted', context: context),
          ),
          SizedBox(height: 15.0),
          Image.asset(
            "assets/slide_3.png",
            fit: BoxFit.contain,
            height: 250,
          ),
          SizedBox(height: 15.0),
          Center(
            child: BoldText4(
              text: 'Unable to fetch nearby Businesses because Location Services are not Granted.',
              context: context
            ),
          ),
        ],
      )
    );
  }
}