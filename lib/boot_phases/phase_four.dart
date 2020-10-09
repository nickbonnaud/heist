import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/repositories/beacon_repository.dart';
import 'package:heist/screens/boot.dart';

class PhaseFour extends StatelessWidget {
  final BeaconRepository _beaconRepository = BeaconRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BeaconBloc>(
          create: (BuildContext context) => BeaconBloc(
            beaconRepository: _beaconRepository,
            activeLocationBloc: BlocProvider.of<ActiveLocationBloc>(context),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context)
          )
        ),

        BlocProvider<NotificationBootBloc>(
          create: (_) => NotificationBootBloc(
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
            openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context)
          ),
        ),

        BlocProvider<ReceiptModalSheetBloc>(
          create: (_) => ReceiptModalSheetBloc(),
        ),
      ], 
      child: Boot()
    );
  }
}