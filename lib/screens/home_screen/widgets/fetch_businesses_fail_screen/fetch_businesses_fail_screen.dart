import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';

class FetchBusinessesFailScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
      builder: (context, state) {
        return ErrorScreen(
          body: "Oops! An error occurred fetching nearby businesses!\n\n Please try again.",
          buttonText: state is Loading ? "Fetching" : "Retry",
          onButtonPressed: state is Loading 
            ? null 
            : () => BlocProvider.of<NearbyBusinessesBloc>(context).add(FetchNearby(
                lat: BlocProvider.of<GeoLocationBloc>(context).currentLocation['lat'],
                lng: BlocProvider.of<GeoLocationBloc>(context).currentLocation['lng'],
              )),
        );
      },
    );
  }
}