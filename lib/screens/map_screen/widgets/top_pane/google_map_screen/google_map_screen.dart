import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/screens/business_screen/business_screen.dart'; 
import 'package:heist/screens/map_screen/helpers/pre_marker.dart';

import 'fetch_markers_fail.dart';
import 'no_nearby_locations.dart';

class GoogleMapScreen extends StatelessWidget {
  final double _latitude;
  final double _longitude;

  GoogleMapScreen({@required double latitude, @required double longitude})
    : assert(latitude != null && longitude != null),
      _latitude = latitude,
      _longitude = longitude;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
      builder: (context, state) {
        if (state is NearbyUninitialized) {
          return Scaffold(
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude, _longitude),
                zoom: 14.0
              ),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()
                )
              ].toSet(),
              markers: [_createCustomerLocationMarker()].toSet(),
              myLocationButtonEnabled: false,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.my_location),
              onPressed: () => _changeLocation(context),
            ),
          );
        } else if (state is NearbyBusinessLoaded) {
          return Scaffold(
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude, _longitude),
                zoom: 14.0,
              ),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()
                )
              ].toSet(),
              markers: _createMarkers(state.preMarkers, context),
              myLocationButtonEnabled: false,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.my_location),
              onPressed: () => _changeLocation(context),
            ),
          );
        } else if (state is NoNearby) {
          return NoNearbyLocations();
        } else {
          return FetchMarkersFail(latitude: _latitude, longitude: _longitude);
        }
      }
    );
  }

  Marker _createCustomerLocationMarker() {
    return Marker(
      markerId: MarkerId('customer_marker'),
      position: LatLng(_latitude, _longitude)
    );
  }

  void _changeLocation(BuildContext context) {
    BlocProvider.of<GeoLocationBloc>(context).add(FetchLocation(accuracy: Accuracy.MEDIUM));
  }

  Set<Marker> _createMarkers(List<PreMarker> preMarkers, BuildContext context) {
    return preMarkers.map((PreMarker preMarker) {
      return Marker(
        markerId: MarkerId(preMarker.markerId),
        position: LatLng(preMarker.lat, preMarker.lng),
        icon: preMarker.icon,
        consumeTapEvents: true,
        onTap: () => showPlatformModalSheet(
          context: context,
          builder: (_) => PlatformWidget(
            android: (_) => BusinessScreen(business: preMarker.business),
            ios: (_) => BusinessScreen(business: preMarker.business),
          )
        )
      );
    }).toSet();
  }
}