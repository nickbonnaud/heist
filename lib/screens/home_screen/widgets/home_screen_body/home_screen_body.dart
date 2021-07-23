import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';

import 'widgets/fetch_businesses_fail_screen/fetch_businesses_fail_screen.dart';
import 'widgets/nearby_businesses_map/nearby_businesses_map.dart';
import 'widgets/no_nearby_locations/no_nearby_locations.dart';
import 'widgets/peek_sheet/peek_sheet.dart';

class HomeScreenBody extends StatelessWidget {
  final NearbyBusinessesBloc _nearbyBusinessesBloc;
  final GeoLocationBloc _geoLocationBloc;

  HomeScreenBody({required NearbyBusinessesBloc nearbyBusinessesBloc, required GeoLocationBloc geoLocationBloc})
    : _nearbyBusinessesBloc = nearbyBusinessesBloc,
      _geoLocationBloc = geoLocationBloc;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
        builder: (context, state) {
          if (state is NearbyBusinessLoaded) {
            
            if (state.businesses.length == 0) {
              return NoNearbyLocations();
            }

            return Stack(
              children: <Widget>[
                NearbyBusinessesMap(preMarkers: state.preMarkers),
                PeekSheet()
              ],
            );
          }
          return FetchBusinessesFailScreen(
            nearbyBusinessesBloc: _nearbyBusinessesBloc,
            geoLocationBloc: _geoLocationBloc,
          );
        },
      ),
    );
  }
}