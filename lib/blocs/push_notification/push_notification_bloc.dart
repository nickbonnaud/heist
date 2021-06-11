import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/providers/push_notification_provider.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/push_notification_handlers/action_button_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/app_opened_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/message_received_handler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationRepository _pushNotificationRepository;
  final TransactionRepository _transactionRepository;
  final BusinessRepository _businessRepository;

  late StreamSubscription _notificationBootBlocSubscription;

  PushNotificationBloc({
    required BuildContext context,
    required PushNotificationRepository pushNotificationRepository,
    required TransactionRepository transactionRepository,
    required BusinessRepository businessRepository,
    required NotificationBootBloc notificationBootBloc
  })
    : _pushNotificationRepository = pushNotificationRepository,
      _transactionRepository = transactionRepository,
      _businessRepository = businessRepository,
      super(PushNotificatinsUninitialized()) {

        _notificationBootBlocSubscription = notificationBootBloc.stream.listen((NotificationBootState state) {
          if (state.isReady) {
            add(StartPushNotificationMonitoring(
              onMessageReceived: ((OSNotificationReceivedEvent notificationReceivedEvent) {
                MessageReceivedHandler handler = MessageReceivedHandler(
                  transactionRepository: _transactionRepository
                );
                handler.init(context: context, oSNotification: notificationReceivedEvent.notification);
              }),
              onMessageInteraction: ((OSNotificationOpenedResult interaction) {
                if (interaction.action?.actionId != null) {
                  ActionButtonHandler handler = ActionButtonHandler(transactionRepository: _transactionRepository);
                  handler.init(context: context, interaction: interaction);
                } else {
                  AppOpenedHandler handler = AppOpenedHandler(
                    transactionRepository: _transactionRepository,
                    businessRepository: _businessRepository
                  );
                  handler.init(context: context, interaction: interaction);
                }
              })
            ));
          }
        });
      }

  @override
  Stream<PushNotificationState> mapEventToState(PushNotificationEvent event) async* {
    if (event is StartPushNotificationMonitoring) {
      yield* _mapStartMonitoringToState(event);
    }
  }

  @override
  Future<void> close() {
    _notificationBootBlocSubscription.cancel();
    return super.close();
  }

  Stream<PushNotificationState> _mapStartMonitoringToState(StartPushNotificationMonitoring event) async* {
    _pushNotificationRepository.startMonitoring(onMessageReceived: event.onMessageReceived, onMessageInteraction: event.onMessageInteraction);
    yield MonitoringPushNotifications();
  }
}
