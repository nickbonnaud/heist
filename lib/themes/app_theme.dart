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
        data: _createTheme(context: context),
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
    final Color _primary = Colors.white;
    final Color _primaryVariant = Colors.grey[300];
    final Color _constrastPrimary = Colors.black;

    final Color _secondary = Colors.grey[800];
    final Color _secondaryVariant = Colors.black;
    final Color _constrastSecondary = Colors.white;
    
    return ThemeData(
      iconTheme: IconThemeData(
        color: Color(0xFF016fb9)
      ),
      appBarTheme: AppBarTheme(
        textTheme: _getTextTheme(context: context)
      ),

      colorScheme: ColorScheme(
        primary: _primary, 
        primaryVariant: _primaryVariant,
        onPrimary: _constrastPrimary,

        secondary: _secondary,
        secondaryVariant: _secondaryVariant, 
        onSecondary: _constrastSecondary, 

        surface: Colors.grey,
        onSurface: Colors.black,
        background: _primary,
        onBackground: _constrastPrimary, 

        error: Colors.red,  
        onError: Colors.white, 
        brightness: Brightness.light,
      ),
      textTheme: _getTextTheme(context: context),
      buttonColor: Color(0xFF016fb9),
      disabledColor: Color(0xFFcce2f1),
    );
  }

  TextTheme _getTextTheme({@required BuildContext context}) {
    return GoogleFonts.racingSansOneTextTheme(Theme.of(context).textTheme);
  }
}
