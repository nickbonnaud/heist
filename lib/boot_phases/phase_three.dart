import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/boot_phases/phase_four.dart';
import 'package:heist/repositories/location_repository.dart';

class PhaseThree extends StatelessWidget {
  final LocationRepository _locationRepository = LocationRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NearbyBusinessesBloc>(
          create: (_) => NearbyBusinessesBloc(
            locationRepository: _locationRepository,
            geoLocationBloc: BlocProvider.of<GeoLocationBloc>(context)
          )
        ),
      ], 
      child: PhaseFour()
    );
  }
}