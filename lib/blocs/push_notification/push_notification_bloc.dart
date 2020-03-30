import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:meta/meta.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';

enum CallBackType {
  ON_MESSAGE,
  ON_LAUNCH,
  ON_RESUME,
}

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
      yield* _mapStartMonitoringToState();
    } else if (event is OnMessageReceived) {
      yield PushNotificationCallBackActivated(type: CallBackType.ON_MESSAGE, message: event.message);
    } else if (event is OnLaunchReceived) {
      yield PushNotificationCallBackActivated(type: CallBackType.ON_LAUNCH, message: event.message);
    } else if (event is OnResumeReceived) {
      yield PushNotificationCallBackActivated(type: CallBackType.ON_RESUME, message: event.message);
    } else if (event is PushNotificationCallBackFinished) {
      yield MonitoringPushNotifications();
    }
  }

  Stream<PushNotificationState> _mapStartMonitoringToState() async* {
    _pushNotificationRepository.startMonitoring(_onMessage, _onLaunch, _onResume);
    yield MonitoringPushNotifications();
  }

  Future<void> _onMessage(Map<String, dynamic> message) async {
    add(OnMessageReceived(message: message));
  }

  Future<void> _onLaunch(Map<String, dynamic> message) async {
    add(OnLaunchReceived(message: message));
  }

  Future<void> _onResume(Map<String, dynamic> message) async {
    add(OnResumeReceived(message: message));
  }
}
