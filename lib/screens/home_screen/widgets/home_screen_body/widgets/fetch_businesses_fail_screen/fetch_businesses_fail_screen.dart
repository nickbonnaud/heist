import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';

class FetchBusinessesFailScreen extends StatelessWidget {

  const FetchBusinessesFailScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
      builder: (context, state) {
        return ErrorScreen(
          body: "Oops! An error occurred fetching nearby businesses!",
          buttonText: state is Loading ? "Fetching" : "Retry",
          onButtonPressed: state is Loading 
            ? null 
            : () => _retryButtonPressed(context: context)
        );
      },
    );
  }

  void _retryButtonPressed({required BuildContext context}) {
    GeoLocationBloc geoLocationBloc = BlocProvider.of<GeoLocationBloc>(context);
    NearbyBusinessesBloc nearbyBusinessesBloc = BlocProvider.of<NearbyBusinessesBloc>(context);

    if (geoLocationBloc.currentLocation == null) {
      geoLocationBloc.add(const FetchLocation(accuracy: Accuracy.medium));
    } else {
      nearbyBusinessesBloc.add(FetchNearby(
        lat: geoLocationBloc.currentLocation!['lat']!,
        lng: geoLocationBloc.currentLocation!['lng']!,
      ));
    }
  }
}