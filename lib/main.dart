import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/themes/app_theme.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final CustomerRepository _customerRepository = CustomerRepository();
  final InitialLoginRepository _initialLoginRepository = InitialLoginRepository();
  final GeolocatorRepository _geolocatorRepository = GeolocatorRepository();
  final ActiveLocationRepository _activeLocationRepository = ActiveLocationRepository();
  final PushNotificationRepository _pushNotificationRepository = PushNotificationRepository();
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: SystemUiOverlayStyle.dark.systemNavigationBarColor
    )
  );
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(customerRepository: _customerRepository)
            ..add(AppStarted()),
        ),
        BlocProvider<BootBloc>(
          create: (_) => BootBloc()
        ),
        BlocProvider<PermissionsBloc>(
          create: (BuildContext context) => PermissionsBloc(initialLoginRepository: _initialLoginRepository)
            ..add(CheckPermissions())
        ),
        BlocProvider<GeoLocationBloc>(
          create: (_) => GeoLocationBloc(geolocatorRepository: _geolocatorRepository)
        ),
        BlocProvider<ActiveLocationBloc>(
          create: (BuildContext context) => ActiveLocationBloc(activeLocationRepository: _activeLocationRepository),
        ),
        BlocProvider<PushNotificationBloc>(
          create: (BuildContext context) => PushNotificationBloc(pushNotificationRepository: _pushNotificationRepository),
        ),
      ],
      child: AppTheme()
    )
  );
}



