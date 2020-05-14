import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';

import 'fetch_location_fail.dart';
import 'google_map_screen/google_map_screen.dart';
import 'loading_location.dart';
import 'permission_denied.dart';

class TopPane extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<GeoLocationBloc, GeoLocationState>(
        builder: (context, state) {
          if (state is LocationLoaded) {
            return Expanded(child: GoogleMapScreen(latitude: state.latitude, longitude: state.longitude)); 
          } else if (state is PermissionNotGranted) {
            return PermissionDenied();
          } else if (state is Loading) {
            return LoadingLocation();
          } else {
            return FetchLocationFail();
          }
        }
      )
    );
  }
}