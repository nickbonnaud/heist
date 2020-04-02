import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/repositories/beacon_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/repositories/onboard_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/themes/default_theme.dart';

import 'screens/home_screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final ActiveLocationRepository _activeLocationRepository = ActiveLocationRepository();
  final OnboardRepository _onboardRepository = OnboardRepository();
  final GeolocatorRepository _geolocatorRepository = GeolocatorRepository();
  final LocationRepository _locationRepository = LocationRepository();
  final BeaconRepository _beaconRepository = BeaconRepository();
  final PushNotificationRepository _pushNotificationRepository = PushNotificationRepository();
  final CustomerRepository _customerRepository = CustomerRepository();
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: SystemUiOverlayStyle.dark.systemNavigationBarColor
    )
  );
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ActiveLocationBloc>(
          create: (BuildContext context) => ActiveLocationBloc(activeLocationRepository: _activeLocationRepository),
        ),
        BlocProvider<CustomerBloc>(
          create: (BuildContext context) => CustomerBloc(),
        ),
        BlocProvider<GeoLocationBloc>(
          create: (BuildContext context) => GeoLocationBloc(geolocatorRepository: _geolocatorRepository)
        ),
        BlocProvider<NearbyBusinessesBloc>(
          create: (BuildContext context) => NearbyBusinessesBloc(locationRepository: _locationRepository)
        ),
        BlocProvider<BeaconBloc>(
          create: (BuildContext context) => BeaconBloc(beaconRepository: _beaconRepository, activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context))
        ),
        BlocProvider<PushNotificationBloc>(
          create: (BuildContext context) => PushNotificationBloc(pushNotificationRepository: _pushNotificationRepository)
        ),
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(customerRepository: _customerRepository, customerBloc: BlocProvider.of<CustomerBloc>(context)),
        ),
        BlocProvider<PermissionsBloc>(
          create: (BuildContext context) => PermissionsBloc(onboardRepository: _onboardRepository)
        ),
      ],
      child: App()
    )
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    BlocProvider.of<PermissionsBloc>(context).add(CheckPermissions());
    return MultiBlocListener(
      listeners: [
        BlocListener<PermissionsBloc, PermissionsState>(
          listener: (context, state) {
            if (state.onStartPermissionsValid) {
              BlocProvider.of<GeoLocationBloc>(context)..add(GeoLocationReady());
              BlocProvider.of<PushNotificationBloc>(context)..add(StartPushNotificationMonitoring());
            }
          },
        ),
        BlocListener<GeoLocationBloc, GeoLocationState>(
          listener: (context , state) {
            if (state is LocationLoaded) {
              BlocProvider.of<NearbyBusinessesBloc>(context)..add(FetchNearby(lat: state.latitude, lng: state.longitude));
            }
          }
        ),
        BlocListener<NearbyBusinessesBloc, NearbyBusinessesState>(
          listener: (context , state) {
            if (state is NearbyBusinessLoaded) {
              BlocProvider.of<BeaconBloc>(context)..add(StartBeaconMonitoring(businesses: state.businesses));
            }
          },
        ),
        BlocListener<PushNotificationBloc, PushNotificationState>(
          listener: (context, state) {
            if (state is PushNotificationCallBackActivated) {
              // handle push notification callbacks
            }
          }
        )
      ],
      child: AppTheme()
    );
  }
}

class AppTheme extends StatelessWidget {
  final materialTheme = new ThemeData(
    primarySwatch: Colors.purple,
  );

  final materialDarkTheme = new ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
  );

  final cupertinoTheme = new CupertinoThemeData(
    brightness: null,
    primaryColor: CupertinoDynamicColor.withBrightness(
      color: Colors.purple,
      darkColor: Colors.cyan,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: defaultTheme,
      child: PlatformProvider(
        builder: (context) {
          return PlatformApp(
            title: Constants.appName,
            localizationsDelegates: [
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
            ],
            android: (_) {
              return new MaterialAppData(
                theme: materialTheme,
                darkTheme: materialDarkTheme,
                themeMode: ThemeMode.system
              );
            },
            ios: (_) => new CupertinoAppData(
              theme: cupertinoTheme,
            ),
            home: HomeScreen(),
          );
        } 
      )
    );
  }
}