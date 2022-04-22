import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/screens/splash_screen/splash_screen.dart';

import 'bloc/app_ready_bloc.dart';

class App extends StatelessWidget {

  const App({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previousState, currentState) => previousState is Unknown,
      builder: (context, state) => BlocProvider<AppReadyBloc>(
        create: (context) => AppReadyBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
          beaconBloc: BlocProvider.of<BeaconBloc>(context),
          nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
          permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
          customerBloc: BlocProvider.of<CustomerBloc>(context)
        ),
        child: const SplashScreen(),
      )
    );
  }
}