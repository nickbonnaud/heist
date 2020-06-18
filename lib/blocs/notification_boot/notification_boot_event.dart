part of 'notification_boot_bloc.dart';


abstract class NotificationBootEvent extends Equatable {
  const NotificationBootEvent();

  @override
  List<Object> get props => [];
}

class NearbyBusinessesReady extends NotificationBootEvent {}

class OpenTransactionsReady extends NotificationBootEvent {}

class PermissionReady extends NotificationBootEvent {}
