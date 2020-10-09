import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/boot_phases/phase_two.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';

class PhaseOne extends StatelessWidget {
  final CustomerRepository _customerRepository = CustomerRepository();
  final ActiveLocationRepository _activeLocationRepository = ActiveLocationRepository();
  final InitialLoginRepository _initialLoginRepository = InitialLoginRepository();
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(customerRepository: _customerRepository)
            ..add(AppStarted()),
        ),
        BlocProvider<ActiveLocationBloc>(
          create: (_) => ActiveLocationBloc(activeLocationRepository: _activeLocationRepository),
        ),
        BlocProvider<PermissionsBloc>(
          create: (_) => PermissionsBloc(initialLoginRepository: _initialLoginRepository)
            ..add(CheckPermissions())
        ),
      ],
      child: PhaseTwo()
    );
  }
}