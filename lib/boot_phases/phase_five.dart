import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:heist/providers/push_notification_provider.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/boot.dart';

class PhaseFive extends StatelessWidget {
  final TransactionRepository _transactionRepository;
  final MaterialApp? _testApp;
  final PushNotificationRepository _pushNotificationRepository = PushNotificationRepository(pushNotificationProvider: PushNotificationProvider());
  final BusinessRepository _businessRepository = BusinessRepository(businessProvider: BusinessProvider());

  PhaseFive({required TransactionRepository transactionRepository, MaterialApp? testApp})
    : _transactionRepository = transactionRepository,
      _testApp = testApp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PushNotificationBloc>(
      create: (context) => PushNotificationBloc(
        context: context,
        pushNotificationRepository: _pushNotificationRepository,
        businessRepository: _businessRepository,
        transactionRepository: _transactionRepository,
        notificationBootBloc: BlocProvider.of<NotificationBootBloc>(context)
      ),
      child: Boot(testApp: _testApp),
    );
  }
}