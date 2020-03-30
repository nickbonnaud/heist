part of 'push_notification_bloc.dart';

abstract class PushNotificationState extends Equatable {
  const PushNotificationState();

  @override
  List<Object> get props => [];
}

class PushNotificatinsUninitialized extends PushNotificationState {}

class MonitoringPushNotifications extends PushNotificationState {}

class PushNotificationCallBackActivated extends PushNotificationState {
  final CallBackType type;
  final Map<dynamic, dynamic> message;

  PushNotificationCallBackActivated({@required this.type, @required this.message});

  @override
  List<Object> get props => [type, message];

  @override
  String toString() => 'PushNotificationCallBackActivated { type: $type, message: $message }';
}