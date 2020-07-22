import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NearbyBusinessesBloc>(
          create: (_) => NearbyBusinessesBloc(
            locationRepository: _locationRepository,
            bootBloc: BlocProvider.of<BootBloc>(context)
          )
        ),
        BlocProvider<BeaconBloc>(
          create: (BuildContext context) => BeaconBloc(
            beaconRepository: _beaconRepository,
            activeLocationBloc:
                BlocProvider.of<ActiveLocationBloc>(context),
            bootBloc: BlocProvider.of<BootBloc>(context)
          )
        ),
        BlocProvider<OpenTransactionsBloc>(
          create: (_) => OpenTransactionsBloc(
            transactionRepository: _transactionRepository,
            bootBloc: BlocProvider.of<BootBloc>(context)
          ),
        )
      ],
      child: Theme(
        data: defaultTheme,
        child: PlatformProvider(builder: (context) {
          return MaterialApp(
            title: Constants.appName,
            localizationsDelegates: [
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
            ],
            theme: _createTheme(context: context),
            home: Boot(),
          );
        })
      )
    );
  }

  ThemeData _createTheme({@required BuildContext context}) {
    return ThemeData(
      iconTheme: IconThemeData(
        color: Colors.orange
      ),
      appBarTheme: AppBarTheme(
        textTheme: _getTextTheme(context: context)
      ),
      primarySwatch: Colors.green,
      accentColor: Colors.orange,

      colorScheme: ColorScheme(
        primary: Colors.green, 
        primaryVariant: Colors.green[800],
        onPrimary: Colors.white,

        secondary: Colors.orange, 
        secondaryVariant: Colors.orange[800], 
        onSecondary: Colors.white, 

        surface: Colors.grey,
        onSurface: Colors.green,
        background: Colors.white,
        onBackground: Colors.orange, 

        error: Colors.red,  
        onError: Colors.white, 
        brightness: Brightness.light,
      ),
      textTheme: _getTextTheme(context: context),
      buttonColor: Colors.orange,
      disabledColor: Colors.orange.shade100,
    );
  }

  TextTheme _getTextTheme({@required BuildContext context}) {
    return GoogleFonts.racingSansOneTextTheme(Theme.of(context).textTheme);
  }
}
