part of 'notification_navigation_bloc.dart';

@immutable
class NotificationNavigationState extends Equatable {
  final String? route;
  final Object? arguments;

  NotificationNavigationState({required this.route, required this.arguments});

  factory NotificationNavigationState.empty() => NotificationNavigationState(
    route: null,
    arguments: null
  );

  NotificationNavigationState update({
    String? route,
    Object? arguments
  }) => NotificationNavigationState(
    route: route ?? this.route,
    arguments: arguments ?? this.arguments
  );
  
  @override
  List<Object?> get props => [route, arguments];

  @override
  String toString() => 'NotificationNavigationState { route: $route, arguments: $arguments }';
}
