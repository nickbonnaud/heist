import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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

class PhaseTwo extends StatelessWidget {
  final PlatformProvider? _testApp;
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository(tokenRepository: TokenRepository(tokenProvider: StorageProvider()), authenticationProvider: AuthenticationProvider());
  final GeolocatorRepository _geolocatorRepository = GeolocatorRepository(geolocatorProvider: GeolocatorProvider());

  PhaseTwo({PlatformProvider? testApp})
    : _testApp = testApp;
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: _authenticationRepository,
            customerBloc: BlocProvider.of<CustomerBloc>(context)
          )..add(Init())
        ),

        BlocProvider<GeoLocationBloc>(
          create: (_) => GeoLocationBloc(
            geolocatorRepository: _geolocatorRepository,
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context)
          )
        ),
      ], 
      child: PhaseThree(testApp: _testApp)
    );
  }
}