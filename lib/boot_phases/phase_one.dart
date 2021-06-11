import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/boot_phases/phase_two.dart';
import 'package:heist/providers/active_location_provider.dart';
import 'package:heist/providers/customer_provider.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/repositories/token_repository.dart';

class PhaseOne extends StatelessWidget {
  final MaterialApp? _testApp;
  final CustomerRepository _customerRepository = CustomerRepository(customerProvider: CustomerProvider(), tokenRepository: TokenRepository(tokenProvider: StorageProvider()));
  final ActiveLocationRepository _activeLocationRepository = ActiveLocationRepository(activeLocationProvider: ActiveLocationProvider());
  final InitialLoginRepository _initialLoginRepository = InitialLoginRepository(tutorialProvider: StorageProvider());
  
  PhaseOne({MaterialApp? testApp})
    : _testApp = testApp;
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerBloc>(
          create: (_) => CustomerBloc(customerRepository: _customerRepository)
        ),

        BlocProvider<ActiveLocationBloc>(
          create: (_) => ActiveLocationBloc(activeLocationRepository: _activeLocationRepository),
        ),
        
        BlocProvider<PermissionsBloc>(
          create: (_) => PermissionsBloc(initialLoginRepository: _initialLoginRepository)
            ..add(CheckPermissions())
        ),
      ],
      child: PhaseTwo(testApp: _testApp)
    );
  }
}