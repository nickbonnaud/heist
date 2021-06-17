import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/splash_screen/splash_screen.dart';

import 'bloc/app_ready_bloc.dart';

class App extends StatelessWidget {
  final AuthenticationBloc _authenticationBloc;
  final OpenTransactionsBloc _openTransactionsBloc;
  final BeaconBloc _beaconBloc;
  final NearbyBusinessesBloc _nearbyBusinessesBloc;
  final PermissionsBloc _permissionsBloc;
  final CustomerBloc _customerBloc;

  App({
    required AuthenticationBloc authenticationBloc,
    required OpenTransactionsBloc openTransactionsBloc,
    required BeaconBloc beaconBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    required PermissionsBloc permissionsBloc,
    required CustomerBloc customerBloc
  })
    : _authenticationBloc = authenticationBloc,
      _openTransactionsBloc = openTransactionsBloc,
      _beaconBloc = beaconBloc,
      _nearbyBusinessesBloc = nearbyBusinessesBloc,
      _permissionsBloc = permissionsBloc,
      _customerBloc = customerBloc;
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previousState, currentState) {
            return previousState is Authenticated && currentState is Unauthenticated;
          },
          listener: (context, state) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.auth, (route) => false);
          },
        ),
        BlocListener<NotificationNavigationBloc, NotificationNavigationState>(
          listenWhen: (previousState, currentState) {
            return previousState.route == null && currentState.route != null;
          },
          listener: (context, state) {
            if (BlocProvider.of<ReceiptModalSheetBloc>(context).isVisible) Navigator.of(context).pop();
            Navigator.of(context).pushNamed(state.route!, arguments: state.arguments);
            BlocProvider.of<NotificationNavigationBloc>(context).add(ResetFromNotification());
          }
        )
      ], 
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previousState, currentState) => previousState is Unknown,
        builder: (context, state) => BlocProvider<AppReadyBloc>(
          create: (context) => AppReadyBloc(
            authenticationBloc: _authenticationBloc,
            openTransactionsBloc: _openTransactionsBloc,
            beaconBloc: _beaconBloc,
            nearbyBusinessesBloc: _nearbyBusinessesBloc,
            permissionsBloc: _permissionsBloc,
            customerBloc: _customerBloc
          ),
          child: SplashScreen(),
        )
      )
    );
  }
}