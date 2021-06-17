import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/providers/push_notification_provider.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/external_url_handler.dart';
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
  final OpenTransactionsBloc _openTransactionsBloc;
  final NearbyBusinessesBloc _nearbyBusinessesBloc;
  final NotificationNavigationBloc _notificationNavigationBloc;
  final ExternalUrlHandler _externalUrlHandler;

  late StreamSubscription _notificationBootBlocSubscription;

  PushNotificationBloc({
    required PushNotificationRepository pushNotificationRepository,
    required TransactionRepository transactionRepository,
    required BusinessRepository businessRepository,
    required NotificationBootBloc notificationBootBloc,
    required OpenTransactionsBloc openTransactionsBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    required NotificationNavigationBloc notificationNavigationBloc,
    required ExternalUrlHandler externalUrlHandler
  })
    : _pushNotificationRepository = pushNotificationRepository,
      _transactionRepository = transactionRepository,
      _businessRepository = businessRepository,
      _openTransactionsBloc = openTransactionsBloc,
      _nearbyBusinessesBloc = nearbyBusinessesBloc,
      _notificationNavigationBloc = notificationNavigationBloc,
      _externalUrlHandler = externalUrlHandler,
      super(PushNotificatinsUninitialized()) {

        _notificationBootBlocSubscription = notificationBootBloc.stream.listen((NotificationBootState state) {
          if (state.isReady) {
            add(StartPushNotificationMonitoring(
              onMessageReceived: ((OSNotificationReceivedEvent notificationReceivedEvent) {
                MessageReceivedHandler handler = MessageReceivedHandler(
                  transactionRepository: _transactionRepository,
                  openTransactionsBloc: _openTransactionsBloc
                );
                handler.init(notification: PushNotification.fromOsNotification(notification: notificationReceivedEvent.notification));
              }),
              onMessageInteraction: ((OSNotificationOpenedResult interaction) {
                if (interaction.action?.actionId != null) {
                  ActionButtonHandler handler = ActionButtonHandler(
                    transactionRepository: _transactionRepository,
                    openTransactionsBloc: _openTransactionsBloc,
                    notificationNavigationBloc: _notificationNavigationBloc,
                    externalUrlHandler: _externalUrlHandler
                  );
                  handler.init(notification: PushNotification.fromOsNotificationOpened(interaction: interaction), actionId: interaction.action!.actionId!);
                } else {
                  AppOpenedHandler handler = AppOpenedHandler(
                    transactionRepository: _transactionRepository,
                    businessRepository: _businessRepository,
                    openTransactionsBloc: _openTransactionsBloc,
                    nearbyBusinessesBloc: _nearbyBusinessesBloc,
                    notificationNavigationBloc: _notificationNavigationBloc
                  );
                  handler.init(notification: PushNotification.fromOsNotificationOpened(interaction: interaction));
                }
              })
            ));
          }
        });
      }

  @override
  Stream<PushNotificationState> mapEventToState(PushNotificationEvent event) async* {
    if (event is StartPushNotificationMonitoring) {
      yield* _mapStartMonitoringToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _notificationBootBlocSubscription.cancel();
    return super.close();
  }

  Stream<PushNotificationState> _mapStartMonitoringToState({required StartPushNotificationMonitoring event}) async* {
    _pushNotificationRepository.startMonitoring(onMessageReceived: event.onMessageReceived, onMessageInteraction: event.onMessageInteraction);
    yield MonitoringPushNotifications();
  }
}
