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
import 'package:heist/resources/helpers/permissions_checker.dart';
import 'package:heist/test_blocs/is_testing_cubit.dart';

class PhaseOne extends StatelessWidget {
  final bool _testing;
  
  const PhaseOne({bool testing = false, Key? key})
    : _testing = testing,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerBloc>(
          create: (_) => CustomerBloc(customerRepository: CustomerRepository(customerProvider: CustomerProvider(), tokenRepository: TokenRepository(tokenProvider: StorageProvider())))
        ),

        BlocProvider<ActiveLocationBloc>(
          create: (_) => ActiveLocationBloc(activeLocationRepository: ActiveLocationRepository(activeLocationProvider: ActiveLocationProvider())),
        ),
        
        BlocProvider<PermissionsBloc>(
          create: (_) => PermissionsBloc(
            initialLoginRepository: InitialLoginRepository(tutorialProvider: StorageProvider()),
            permissionsChecker: PermissionsChecker()
          )
        ),

        BlocProvider<IsTestingCubit>(create: (_) => IsTestingCubit(testing: _testing))
      ],
      child: const PhaseTwo()
    );
  }
}