import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/boot_phases/phase_five.dart';
import 'package:heist/providers/beacon_provider.dart';
import 'package:heist/repositories/beacon_repository.dart';
import 'package:heist/test_blocs/is_testing_cubit.dart';

class PhaseFour extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BeaconBloc>(
          create: (BuildContext context) => BeaconBloc(
            beaconRepository: BeaconRepository(beaconProvider: BeaconProvider()),
            activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
            testing: context.read<IsTestingCubit>().state
          )
        ),

        BlocProvider<NotificationBootBloc>(
          lazy: false,
          create: (BuildContext context) => NotificationBootBloc(
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
            openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context)
          ),
        ),

        BlocProvider<ReceiptModalSheetBloc>(
          create: (_) => ReceiptModalSheetBloc(),
        ),

        BlocProvider<NotificationNavigationBloc>(
          create: (_) => NotificationNavigationBloc()
        )
      ], 
      child: PhaseFive()
    );
  }
}