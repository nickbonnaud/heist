import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/repositories/beacon_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/boot.dart';

import 'default_theme.dart';

class AppTheme extends StatelessWidget {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final LocationRepository _locationRepository = LocationRepository();
  final BeaconRepository _beaconRepository = BeaconRepository();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<NearbyBusinessesBloc>(
          create: (_) => NearbyBusinessesBloc(locationRepository: _locationRepository, bootBloc: BlocProvider.of<BootBloc>(context))
        ),
        BlocProvider<BeaconBloc>(
          create: (BuildContext context) => BeaconBloc(beaconRepository: _beaconRepository, activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context), bootBloc: BlocProvider.of<BootBloc>(context))
        ),
        BlocProvider<OpenTransactionsBloc>(
          create: (_) => OpenTransactionsBloc(transactionRepository: _transactionRepository, bootBloc: BlocProvider.of<BootBloc>(context)),
        )
      ], 
      child: Theme(
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
              home: Boot()
            );
          } 
        )
      )
    );
  }
}