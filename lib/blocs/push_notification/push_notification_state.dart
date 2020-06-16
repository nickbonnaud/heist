part of 'push_notification_bloc.dart';

abstract class PushNotificationState extends Equatable {
  const PushNotificationState();

  @override
  List<Object> get props => [];
}

class PushNotificatinsUninitialized extends PushNotificationState {}

class MonitoringPushNotifications extends PushNotificationState {}