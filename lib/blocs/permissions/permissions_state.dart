part of 'permissions_bloc.dart';

@immutable
class PermissionsState {
  final bool bleEnabled;
  final bool locationEnabled;
  final bool notificationEnabled;
  final bool beaconEnabled;
  final bool checksComplete;

  bool get allPermissionsValid => bleEnabled && locationEnabled && notificationEnabled && beaconEnabled;
  bool get onStartPermissionsValid => bleEnabled && locationEnabled && beaconEnabled;

  PermissionsState({
    @required this.bleEnabled,
    @required this.locationEnabled,
    @required this.notificationEnabled,
    @required this.beaconEnabled,
    @required this.checksComplete,
  });

  factory PermissionsState.unknown() {
    return PermissionsState(
      bleEnabled: false,
      locationEnabled: false,
      notificationEnabled: false,
      beaconEnabled: false,
      checksComplete: false,
    );
  }

  factory PermissionsState.isInitial() {
    return PermissionsState(
      bleEnabled: false,
      locationEnabled: false,
      notificationEnabled: false,
      beaconEnabled: false,
      checksComplete: true,
    );
  }

  PermissionsState update({
    bool bleEnabled,
    bool locationEnabled,
    bool notificationEnabled,
    bool beaconEnabled,
    bool checksComplete,
  }) {
    return copyWith(
      bleEnabled: bleEnabled,
      locationEnabled: locationEnabled,
      notificationEnabled: notificationEnabled,
      beaconEnabled: beaconEnabled,
      checksComplete: checksComplete,
    );
  }

  PermissionsState copyWith({
    bool bleEnabled,
    bool locationEnabled,
    bool notificationEnabled,
    bool beaconEnabled,
    bool checksComplete,
  }) {
    return PermissionsState(
      bleEnabled: bleEnabled ?? this.bleEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      beaconEnabled: beaconEnabled ?? this.beaconEnabled,
      checksComplete: checksComplete ?? this.checksComplete,
    );
  }

  @override
  String toString() => 'PermissionsState { bleEnabled: $bleEnabled, locationEnabled: $locationEnabled, notificationEnabled: $notificationEnabled, beaconEnabled: $beaconEnabled, checksComplete: $checksComplete }';
}