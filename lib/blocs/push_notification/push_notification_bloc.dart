import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:meta/meta.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';

class PushNotificationBloc extends Bloc<PushNotificationEvent, PushNotificationState> {
  final PushNotificationRepository _pushNotificationRepository;

  PushNotificationBloc({@required PushNotificationRepository pushNotificationRepository})
    : assert(pushNotificationRepository != null),
      _pushNotificationRepository = pushNotificationRepository;
  
  @override
  PushNotificationState get initialState => PushNotificatinsUninitialized();

  @override
  Stream<PushNotificationState> mapEventToState(PushNotificationEvent event) async* {
    if (event is StartPushNotificationMonitoring) {
      yield* _mapStartMonitoringToState(event);
    }
  }

  Stream<PushNotificationState> _mapStartMonitoringToState(StartPushNotificationMonitoring event) async* {
    _pushNotificationRepository.startMonitoring(onMessageReceived: event.onMessageReceived, onMessageInteraction: event.onMessageInteraction);
    yield MonitoringPushNotifications();
  }
}
