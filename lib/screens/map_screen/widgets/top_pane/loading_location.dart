import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/resources/helpers/loading_widget.dart';

class LoadingLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlatformText(
            'Fetching Current Location',
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
          LoadingWidget(),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}