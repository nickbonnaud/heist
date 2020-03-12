part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class AppReady extends PermissionsEvent {}

class LocationPermissionUpdated extends PermissionsEvent {
  final bool isLocationEnabled;

  const LocationPermissionUpdated({@required this.isLocationEnabled});

  @override
  List<Object> get props => [isLocationEnabled];

  @override
  String toString() => 'LocationPermissionUpdated { isLocationEnabled: $isLocationEnabled }';
}

class NotificationPermissionUpdated extends PermissionsEvent {
  final bool isNotificationEnabled;

  const NotificationPermissionUpdated({@required this.isNotificationEnabled});

  @override
  List<Object> get props => [isNotificationEnabled];

  @override
  String toString() => 'NotificationPermissionUpdated { isNotificationEnabled: $isNotificationEnabled }';
}

class BeaconPermissionUpdated extends PermissionsEvent {
  final bool isBeaconEnabled;

  const BeaconPermissionUpdated({@required this.isBeaconEnabled});

  @override
  List<Object> get props => [isBeaconEnabled];

  @override
  String toString() => 'BeaconPermissionUpdated { isBeaconEnabled: $isBeaconEnabled }';
}

class UpdateAllPermissions extends PermissionsEvent {
  final bool isLocationEnabled;
  final bool isNotificationEnabled;
  final bool isBeaconEnabled;

  const UpdateAllPermissions({
    @required this.isLocationEnabled,
    @required this.isNotificationEnabled,
    @required this.isBeaconEnabled
  });

  @override
  List<Object> get props => [isLocationEnabled, isNotificationEnabled, isBeaconEnabled];

  @override
  String toString() => 'LocationPermissionChanged { isLocationEnabled: $isLocationEnabled, isNotificationEnabled: $isNotificationEnabled, isBeaconEnabled: $isBeaconEnabled }';
}
