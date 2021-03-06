import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/boot_phases/phase_four.dart';
import 'package:heist/providers/icon_creator_provider.dart';
import 'package:heist/providers/location_provider.dart';
import 'package:heist/providers/transaction_provider.dart';
import 'package:heist/repositories/icon_creator_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';

class PhaseThree extends StatelessWidget {
  final PlatformProvider? _testApp;
  final TransactionRepository _transactionRepository = TransactionRepository(transactionProvider: TransactionProvider());
  final LocationRepository _locationRepository = LocationRepository(locationProvider: LocationProvider());
  final IconCreatorRepository _iconCreatorRepository = IconCreatorRepository(iconCreatorProvider: IconCreatorProvider());

  PhaseThree({PlatformProvider? testApp})
    : _testApp = testApp;
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OpenTransactionsBloc>(
          create: (_) => OpenTransactionsBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            transactionRepository: _transactionRepository
          )
        ),


        BlocProvider<NearbyBusinessesBloc>(
          create: (_) => NearbyBusinessesBloc(
            locationRepository: _locationRepository,
            iconCreatorRepository: _iconCreatorRepository,
            geoLocationBloc: BlocProvider.of<GeoLocationBloc>(context)
          )
        ),
      ], 
      child: PhaseFour(transactionRepository: _transactionRepository, testApp: _testApp)
    );
  }
}