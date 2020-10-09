import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/boot_phases/phase_three.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';

class PhaseTwo extends StatelessWidget {
  final TransactionRepository _transactionRepository = TransactionRepository();
  
  final GeolocatorRepository _geolocatorRepository = GeolocatorRepository();

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
        BlocProvider<GeoLocationBloc>(
          create: (_) => GeoLocationBloc(
            geolocatorRepository: _geolocatorRepository,
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
          )
        ),
        
      ], 
      child: PhaseThree()
    );
  }
}