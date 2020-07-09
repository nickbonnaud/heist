import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class FetchLocationFail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: BoldText3(text: 'Failed to Fetch Current Location', context: context),
          ),
          SizedBox(height: 15.0),
          Image.asset(
            "assets/slide_4.png",
            fit: BoxFit.contain,
            height: 250,
          ),
          SizedBox(height: 15.0),
          PlatformButton(
            onPressed: () => BlocProvider.of<GeoLocationBloc>(context).add(FetchLocation(accuracy: Accuracy.MEDIUM)),
            child: PlatformText('Try Again'),
          )
        ],
      ),
    );
  }
}