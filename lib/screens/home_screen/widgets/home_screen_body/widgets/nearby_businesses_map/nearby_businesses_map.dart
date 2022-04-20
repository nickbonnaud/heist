import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';

import 'models/pre_marker.dart';
import 'widgets/google_map_screen/bloc/google_map_screen_bloc.dart';
import 'widgets/google_map_screen/google_map_screen.dart';
import 'widgets/loading_location.dart';

class NearbyBusinessesMap extends StatelessWidget {
  final List<PreMarker> _preMarkers;

  const NearbyBusinessesMap({required List<PreMarker> preMarkers, Key? key})
    : _preMarkers = preMarkers,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoLocationBloc, GeoLocationState>(
      builder: (context, state) {
        if (state is LocationLoaded) {
          return BlocProvider<GoogleMapScreenBloc>(
            create: (_) => GoogleMapScreenBloc(),
            child: GoogleMapScreen(
              latitude: state.latitude,
              longitude: state.longitude,
              preMarkers: _preMarkers
            ),
          ); 
        } else {
          return const LoadingLocation();
        }
      },
    );
  }
}