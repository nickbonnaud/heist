part of 'permissions_bloc.dart';

@immutable
class PermissionsState {
  final bool isLocationEnabled;
  final bool isNotificationEnabled;
  final bool isBeaconEnabled;

  PermissionsState({
    @required this.isLocationEnabled,
    @required this.isNotificationEnabled,
    @required this.isBeaconEnabled
  });

  factory PermissionsState.uninitialized() {
    return PermissionsState(
      isLocationEnabled: false,
      isNotificationEnabled: false,
      isBeaconEnabled: false
    );
  }

  PermissionsState update({bool isLocationEnabled, bool isNotificationEnabled, bool isBeaconEnabled}) {
    return copyWith(
      isLocationEnabled: isLocationEnabled,
      isNotificationEnabled: isNotificationEnabled,
      isBeaconEnabled: isBeaconEnabled
    );
  }
  
  PermissionsState copyWith({bool isLocationEnabled, bool isNotificationEnabled, bool isBeaconEnabled}) {
    return PermissionsState(
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isBeaconEnabled: isBeaconEnabled ?? this.isBeaconEnabled
    );
  }
}