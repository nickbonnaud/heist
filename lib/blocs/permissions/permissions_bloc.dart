import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

enum PermissionType {
  beacon,
  location,
  notification,
  bluetooth
}

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final InitialLoginRepository _initialLoginRepository;

  PermissionsBloc({required InitialLoginRepository initialLoginRepository})
    : _initialLoginRepository = initialLoginRepository,
      super(PermissionsState.unknown());

  // bool get isBleEnabled => state.bleEnabled;
  // bool get isLocationEnabled => state.locationEnabled;
  // bool get isNotificationEnabled => state.notificationEnabled;
  // bool get isBeaconEnabled => state.beaconEnabled;
  // bool get areChecksComplete => state.checksComplete;

  bool get allPermissionsValid => state.bleEnabled && state.locationEnabled && state.notificationEnabled && state.beaconEnabled;
  
  int get numberValidPermissions {
    int validPermissions = 0;

    if (state.bleEnabled) validPermissions++;
    if (state.locationEnabled) validPermissions++;
    if (state.notificationEnabled) validPermissions++;
    if (state.beaconEnabled) validPermissions++;
    return validPermissions;
  }

  List<PermissionType> get invalidPermissions {
    List<PermissionType> incompletePermissions = [];
    if (!state.beaconEnabled) incompletePermissions.add(PermissionType.beacon);
    if (!state.locationEnabled) incompletePermissions.add(PermissionType.location);
    if (!state.notificationEnabled) incompletePermissions.add(PermissionType.notification);
    if (!state.bleEnabled) incompletePermissions.add(PermissionType.bluetooth);
    return incompletePermissions;
  }

  @override
  Stream<PermissionsState> mapEventToState(PermissionsEvent event) async* {
    if (event is BleStatusChanged) {
      yield* _mapBleStatusChangedToState(event: event);
    } else if (event is LocationStatusChanged) {
      yield* _mapLocationStatusChangedToState(event: event);
    } else if (event is NotificationStatusChanged) {
      yield* _mapNotificationStatusChangedToState(event: event);
    } else if (event is BeaconStatusChanged) {
      yield* _mapBeaconStatusChangedToState(event: event);
    } else if (event is UpdateAllPermissions) {
      yield* _mapUpdateAllPermissionsToState(event: event);
    } else if (event is IsInitialLogin) {
      yield* _mapIsInitialLoginToState();
    } else if (event is CheckPermissions) {
      yield* _checkPermissions();
    }
  }

  Stream<PermissionsState> _mapBleStatusChangedToState({required BleStatusChanged event}) async* {
    yield state.update(bleEnabled: event.granted);
  }

  Stream<PermissionsState> _mapLocationStatusChangedToState({required LocationStatusChanged event}) async* {
    yield state.update(locationEnabled: event.granted);
  }

  Stream<PermissionsState> _mapNotificationStatusChangedToState({required NotificationStatusChanged event}) async* {
    yield state.update(notificationEnabled: event.granted);
  }

  Stream<PermissionsState> _mapBeaconStatusChangedToState({required BeaconStatusChanged event}) async* {
    yield state.update(beaconEnabled: event.granted);
  }

  Stream<PermissionsState> _mapUpdateAllPermissionsToState({required UpdateAllPermissions event}) async* {
    yield state.update(
      bleEnabled: event.bleGranted,
      locationEnabled: event.locationGranted,
      notificationEnabled: event.notificationGranted,
      beaconEnabled: event.beaconGranted,
      checksComplete: event.checksComplete
    );
  }

  Stream<PermissionsState> _mapIsInitialLoginToState() async* {
    yield PermissionsState.isInitial();
  }
  
  Stream<PermissionsState> _checkPermissions() async* {
    bool isInitial =  await _initialLoginRepository.isInitialLogin();
    if (!isInitial) {
      List results = await Future.wait([
        // * CHECK * //
        // Permission.bluetooth.status.isGranted,
        flutterBeacon.bluetoothState,
        Permission.location.status.isGranted,
        Permission.notification.status.isGranted,
        Permission.locationAlways.status.isGranted
      ]);
      yield state.update(
        // bleEnabled: results[0],
        bleEnabled: results[0] == BluetoothState.stateOn,
        locationEnabled: results[1],
        notificationEnabled: results[2],
        beaconEnabled: results[3],
        checksComplete: true,
      );
    } else {
      add(IsInitialLogin());
    }
  }
}
