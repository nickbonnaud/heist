part of 'notification_navigation_bloc.dart';

abstract class NotificationNavigationEvent extends Equatable {
  const NotificationNavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateTo extends NotificationNavigationEvent {
  final String route;
  final Object? arguments;

  const NavigateTo({required this.route, this.arguments});

  @override
  List<Object?> get props => [route, arguments];

  @override
  String toString() => 'NavigateTo { route: $route, arguments: $arguments }';
}

class ResetFromNotification extends NotificationNavigationEvent {}