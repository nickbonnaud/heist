import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/resources/helpers/text_styles.dart';

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
          Center(
            child: BoldText3(text: 'Failed to Load Markers', context: context),
          ),
          SizedBox(height: 15.0),
          Image.asset(
            "assets/slide_2.png",
            fit: BoxFit.contain,
            height: 250,
          ),
          SizedBox(height: 15.0),
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            onPressed: () => BlocProvider.of<NearbyBusinessesBloc>(context).add(FetchNearby(lat: _latitude, lng: _longitude)),
            child: PlatformText('Try Again'),
          )
        ],
      ),
    );
  }
}