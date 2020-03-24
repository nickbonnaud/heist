import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/screens/map_screen/bloc/map_screen_bloc.dart';

class FetchMarkersFail extends StatelessWidget {
  final double _latitude;
  final double _longitude;

  FetchMarkersFail({@required double latitude, @required double longitude})
    : assert(latitude != null && longitude != null),
      _latitude = latitude,
      _longitude = longitude;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PlatformText(
            'Failed to Load Markers',
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
            "assets/slide_2.png",
            fit: BoxFit.contain,
            height: 250,
          ),
          SizedBox(height: 15.0),
          PlatformButton(
            onPressed: () => BlocProvider.of<MapScreenBloc>(context).add(SendLocation(lat: _latitude, lng: _longitude)),
            child: PlatformText('Try Again'),
          )
        ],
      ),
    );
  }
}