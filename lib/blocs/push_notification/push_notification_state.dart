part of 'push_notification_bloc.dart';

abstract class PushNotificationState extends Equatable {
  const PushNotificationState();

  @override
  List<Object?> get props => [];
}

class PushNotificatinsUninitialized extends PushNotificationState {}

class MonitoringPushNotifications extends PushNotificationState {
  final String? route;
  final Object? arguments;

  const MonitoringPushNotifications({this.route, this.arguments});

  @override
  List<Object?> get props => [route, arguments];

  @override
  String toString() => 'MonitoringPushNotifications { route: $route, arguments: $arguments }';
}