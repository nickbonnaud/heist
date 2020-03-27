part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  List<Object> get props => [];
}

class CheckPermissions extends PermissionsEvent {}

class UpdateAllPermissions extends PermissionsEvent {
  final bool bleGranted;
  final bool locationGranted;
  final bool notificationGranted;
  final bool beaconGranted;

  const UpdateAllPermissions({
    @required this.bleGranted,
    @required this.locationGranted,
    @required this.notificationGranted,
    @required this.beaconGranted
  });

  @override
  List<Object> get props => [bleGranted, locationGranted, notificationGranted, beaconGranted];

  @override
  String toString() => 'UpdateAllPermissions { bleGranted: $bleGranted, locationGranted: $locationGranted, notificationGranted: $notificationGranted, beaconGranted: $beaconGranted }';
}

class BleStatusChanged extends PermissionsEvent {
  final bool granted;

  const BleStatusChanged({@required this.granted});

  @override
  List<Object> get props => [granted];

  @override
  String toString() => 'BleStatusChanged { granted: $granted }';
}

class LocationStatusChanged extends PermissionsEvent {
  final bool granted;

  const LocationStatusChanged({@required this.granted});

  @override
  List<Object> get props => [granted];

  @override
  String toString() => 'LocationStatusChanged { granted: $granted }';
}

class NotificationStatusChanged extends PermissionsEvent {
  final bool granted;

  const NotificationStatusChanged({@required this.granted});

  @override
  List<Object> get props => [granted];

  @override
  String toString() => 'NotificationStatusChanged { granted: $granted }';
}

class BeaconStatusChanged extends PermissionsEvent {
  final bool granted;

  const BeaconStatusChanged({@required this.granted});

  @override
  List<Object> get props => [granted];

  @override
  String toString() => 'BeaconStatusChanged { granted: $granted }';
}
