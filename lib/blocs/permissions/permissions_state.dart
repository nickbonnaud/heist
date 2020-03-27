part of 'permissions_bloc.dart';

@immutable
class PermissionsState {
  final bool bleEnabled;
  final bool locationEnabled;
  final bool notificationEnabled;
  final bool beaconEnabled;

  bool get allPermissionsValid => bleEnabled && locationEnabled && notificationEnabled && beaconEnabled;
  bool get onStartPermissionsValid => bleEnabled && locationEnabled && beaconEnabled;

  PermissionsState({
    @required this.bleEnabled,
    @required this.locationEnabled,
    @required this.notificationEnabled,
    @required this.beaconEnabled
  });

  factory PermissionsState.unknown() {
    return PermissionsState(
      bleEnabled: false,
      locationEnabled: false,
      notificationEnabled: false,
      beaconEnabled: false
    );
  }

  PermissionsState update({
    bool bleEnabled,
    bool locationEnabled,
    bool notificationEnabled,
    bool beaconEnabled
  }) {
    return copyWith(
      bleEnabled: bleEnabled,
      locationEnabled: locationEnabled,
      notificationEnabled: notificationEnabled,
      beaconEnabled: beaconEnabled
    );
  }

  PermissionsState copyWith({
    bool bleEnabled,
    bool locationEnabled,
    bool notificationEnabled,
    bool beaconEnabled
  }) {
    return PermissionsState(
      bleEnabled: bleEnabled ?? this.bleEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      beaconEnabled: beaconEnabled ?? this.beaconEnabled
    );
  }

  @override
  String toString() => 'PermissionsState { bleEnabled: $bleEnabled, locationEnabled: $locationEnabled, notificationEnabled: $notificationEnabled, beaconEnabled: $beaconEnabled }';
}