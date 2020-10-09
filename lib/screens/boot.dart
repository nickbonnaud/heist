import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/repositories/push_notification_repository.dart';

import 'package:heist/themes/app_theme.dart';

class Boot extends StatelessWidget {
  final PushNotificationRepository _pushNotificationRepository = PushNotificationRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PushNotificationBloc>(
          create: (context) => PushNotificationBloc(
            context: context,
            pushNotificationRepository: _pushNotificationRepository,
            notificationBootBloc: BlocProvider.of<NotificationBootBloc>(context)
          ),
        ),
        
        BlocProvider<BootBloc>(
          create: (_) => BootBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
            beaconBloc: BlocProvider.of<BeaconBloc>(context),
            nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
            permissionsBloc: BlocProvider.of<PermissionsBloc>(context),
          ),
        ),
      ], 
      child: AppTheme()
    );
  }
}