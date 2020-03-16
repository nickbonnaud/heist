import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PlatformText(
              'Success!',
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
              "assets/slide_4.png",
              fit: BoxFit.contain,
              height: 350,
            ),
            SizedBox(height: 25.0),
            PlatformText('All your device permissions are set!',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}