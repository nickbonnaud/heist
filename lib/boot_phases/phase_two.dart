import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/boot_phases/phase_three.dart';
import 'package:heist/providers/authentication_provider.dart';
import 'package:heist/providers/geolocator_provider.dart';
import 'package:heist/providers/storage_provider.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:heist/test_blocs/is_testing_cubit.dart';

class PhaseTwo extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: AuthenticationRepository(tokenRepository: TokenRepository(tokenProvider: StorageProvider()), authenticationProvider: AuthenticationProvider()),
            customerBloc: BlocProvider.of<CustomerBloc>(context)
          )
        ),

        BlocProvider<GeoLocationBloc>(
          create: (context) => GeoLocationBloc(
            geolocatorRepository: GeolocatorRepository(geolocatorProvider: GeolocatorProvider(testing: context.read<IsTestingCubit>().state)),
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
          )
        ),
      ], 
      child: PhaseThree()
    );
  }
}