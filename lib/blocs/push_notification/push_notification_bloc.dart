import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/resources/helpers/push_notification_handlers/action_button_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/app_opened_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/message_received_handler.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationRepository _pushNotificationRepository;

  StreamSubscription _notificationBootBlocSubscription;

  PushNotificationBloc({
    @required BuildContext context,
    @required PushNotificationRepository pushNotificationRepository,
    @required NotificationBootBloc notificationBootBloc
  })
    : assert(pushNotificationRepository != null && notificationBootBloc != null),
      _pushNotificationRepository = pushNotificationRepository,
      super(PushNotificatinsUninitialized()) {

        _notificationBootBlocSubscription = notificationBootBloc.listen((NotificationBootState state) {
          if (state.isReady) {
            add(StartPushNotificationMonitoring(
              onMessageReceived: ((OSNotification notification) {
                MessageReceivedHandler handler = MessageReceivedHandler();
                handler.init(context: context, oSNotification: notification);
              }),
              onMessageInteraction: ((OSNotificationOpenedResult interaction) {
                if (interaction.action?.actionId != null) {
                  ActionButtonHandler handler = ActionButtonHandler();
                  handler.init(context: context, interaction: interaction);
                } else {
                  AppOpenedHandler handler = AppOpenedHandler();
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
