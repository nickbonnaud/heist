part of 'push_notification_bloc.dart';

abstract class PushNotificationEvent extends Equatable {
  const PushNotificationEvent();

  @override
  List<Object> get props => [];
}

class StartPushNotificationMonitoring extends PushNotificationEvent {}

class PushNotificationCallBackFinished extends PushNotificationEvent {}

class OnMessageReceived extends PushNotificationEvent {
  final Map<dynamic, dynamic> message;

  OnMessageReceived({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'OnMessageReceived { message: $message }';
}

class OnLaunchReceived extends PushNotificationEvent {
  final Map<dynamic, dynamic> message;

  OnLaunchReceived({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'OnLaunchReceived { message: $message }';
}

class OnResumeReceived extends PushNotificationEvent {
  final Map<dynamic, dynamic> message;

  OnResumeReceived({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'onResumeReceived { message: $message }';
}