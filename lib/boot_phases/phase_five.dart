import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:heist/providers/push_notification_provider.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/boot.dart';
import 'package:heist/resources/helpers/external_url_handler.dart';

class PhaseFive extends StatelessWidget {
  final TransactionRepository _transactionRepository;
  final PlatformProvider? _testApp;
  
  final PushNotificationRepository _pushNotificationRepository = PushNotificationRepository(pushNotificationProvider: PushNotificationProvider());
  final BusinessRepository _businessRepository = BusinessRepository(businessProvider: BusinessProvider());

  PhaseFive({required TransactionRepository transactionRepository, PlatformProvider? testApp})
    : _transactionRepository = transactionRepository,
      _testApp = testApp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PushNotificationBloc>(
      create: (context) => PushNotificationBloc(
        pushNotificationRepository: _pushNotificationRepository,
        businessRepository: _businessRepository,
        transactionRepository: _transactionRepository,
        notificationBootBloc: BlocProvider.of<NotificationBootBloc>(context),
        nearbyBusinessesBloc: BlocProvider.of<NearbyBusinessesBloc>(context),
        openTransactionsBloc: BlocProvider.of<OpenTransactionsBloc>(context),
        notificationNavigationBloc: BlocProvider.of<NotificationNavigationBloc>(context),
        externalUrlHandler: ExternalUrlHandler()
      ),
      child: Boot(testApp: _testApp),
    );
  }
}