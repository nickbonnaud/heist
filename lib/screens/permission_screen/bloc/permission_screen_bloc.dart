import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'permission_screen_event.dart';
part 'permission_screen_state.dart';

enum PermissionType {
  location,
  beacon,
  notification,
  bluetooth
}

const String CURRENT_KEY = 'current';
const String NEXT_KEY = 'next';
const String INCOMPLETE_KEY = 'incomplete';

class PermissionScreenBloc extends Bloc<PermissionScreenEvent, PermissionScreenState> {
  final bool isBluetoothEnabled;
  final bool isLocationEnabled;
  final bool isNotificationEnabled;
  final bool isBeaconEnabled;

  PermissionScreenBloc({
    @required this.isBluetoothEnabled,
    @required this.isLocationEnabled,
    @required this.isNotificationEnabled,
    @required this.isBeaconEnabled
  });
  
  @override
  PermissionScreenState get initialState => _setInitialState(
    bluetoothEnabled: isBluetoothEnabled,
    locationEnabled: isLocationEnabled,
    notificationEnabled: isNotificationEnabled,
    beaconEnabled: isBeaconEnabled
  );

  @override
  Stream<PermissionScreenState> mapEventToState(PermissionScreenEvent event) async* {
    if (event is PermissionChanged) {
      yield* _mapPermissionChangedToState(event.permissionType);
    }
  }

  PermissionScreenState _setInitialState({@required bool bluetoothEnabled, @required bool locationEnabled, @required bool notificationEnabled, @required bool beaconEnabled}) {
    Map<String, dynamic> stateValues = _getStateValues(
      bluetoothEnabled: bluetoothEnabled,
      locationEnabled: locationEnabled,
      notificationEnabled: notificationEnabled,
      beaconEnabled: beaconEnabled
    );
    return PermissionScreenState.init(current: stateValues[CURRENT_KEY], next: stateValues[NEXT_KEY], incomplete: stateValues[INCOMPLETE_KEY]);
  }
  
  Map<String, dynamic> _getStateValues({@required bool bluetoothEnabled, @required bool locationEnabled, @required bool notificationEnabled, @required bool beaconEnabled}) {
    PermissionType current;
    PermissionType next;
    List<PermissionType> incomplete = [];

    current = !beaconEnabled && !Platform.isAndroid ? PermissionType.beacon : null;
    current = !notificationEnabled ? PermissionType.notification : current;
    current = !locationEnabled ? PermissionType.location : current;
    current = !bluetoothEnabled ? PermissionType.bluetooth : current;

    next = !beaconEnabled && !Platform.isAndroid ? PermissionType.beacon : null;
    next = !notificationEnabled ? PermissionType.notification : next;
    next = !locationEnabled ? PermissionType.location : next;

    if (!bluetoothEnabled) incomplete.add(PermissionType.bluetooth);
    if (!locationEnabled) incomplete.add(PermissionType.location);
    if (!notificationEnabled) incomplete.add(PermissionType.notification);
    if (!beaconEnabled && !Platform.isAndroid) incomplete.add(PermissionType.beacon);

    return {CURRENT_KEY: current, NEXT_KEY: next, INCOMPLETE_KEY: incomplete};
  }

  Stream<PermissionScreenState> _mapPermissionChangedToState(PermissionType updatedPermission) async* {
    PermissionType current;
    PermissionType next;
    List<PermissionType> incompleted = [];

    state.incomplete.forEach((PermissionType permission) {
      if (permission != updatedPermission) {
        if (current == null) {
          current = permission;
        } else {
          next = permission;
        }
        incompleted.add(permission);
      }
    });
    yield state.update(current: current, next: next, incomplete: incompleted);
  }
}
