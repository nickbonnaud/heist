import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/boot_phases/phase_four.dart';
import 'package:heist/repositories/icon_creator_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';

class PhaseThree extends StatelessWidget {
  
  const PhaseThree({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OpenTransactionsBloc>(
          create: (context) => OpenTransactionsBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            transactionRepository: const TransactionRepository()
          )
        ),

        BlocProvider<NearbyBusinessesBloc>(
          create: (context) => NearbyBusinessesBloc(
            locationRepository: const LocationRepository(),
            iconCreatorRepository: const IconCreatorRepository(),
            geoLocationBloc: BlocProvider.of<GeoLocationBloc>(context)
          )
        ),
      ], 
      child: const PhaseFour()
    );
  }
}