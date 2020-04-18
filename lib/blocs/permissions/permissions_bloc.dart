import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:heist/repositories/onboard_repository.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final OnboardRepository _onboardRepository;

  PermissionsBloc({@required OnboardRepository onboardRepository})
    : assert(onboardRepository != null),
      _onboardRepository = onboardRepository;
  
  @override
  PermissionsState get initialState => PermissionsState.unknown();

  @override
  Stream<PermissionsState> mapEventToState(PermissionsEvent event) async* {
    if (event is BleStatusChanged) {
      yield* _mapBleStatusChangedToState(event);
    } else if (event is LocationStatusChanged) {
      yield* _mapLocationStatusChangedToState(event);
    } else if (event is NotificationStatusChanged) {
      yield* _mapNotificationStatusChangedToState(event);
    } else if (event is BeaconStatusChanged) {
      yield* _mapBeaconStatusChangedToState(event);
    } else if (event is UpdateAllPermissions) {
      yield* _mapUpdateAllPermissionsToState(event);
    } else if (event is CheckPermissions) {
      _checkPermissions();
    }
  }

  Stream<PermissionsState> _mapBleStatusChangedToState(BleStatusChanged event) async* {
    yield state.update(bleEnabled: event.granted);
  }

  Stream<PermissionsState> _mapLocationStatusChangedToState(LocationStatusChanged event) async* {
    yield state.update(locationEnabled: event.granted);
  }

  Stream<PermissionsState> _mapNotificationStatusChangedToState(NotificationStatusChanged event) async* {
    yield state.update(notificationEnabled: event.granted);
  }

  Stream<PermissionsState> _mapBeaconStatusChangedToState(BeaconStatusChanged event) async* {
    yield state.update(beaconEnabled: event.granted);
  }

  Stream<PermissionsState> _mapUpdateAllPermissionsToState(UpdateAllPermissions event) async* {
    yield state.update(
      bleEnabled: event.bleGranted,
      locationEnabled: event.locationGranted,
      notificationEnabled: event.notificationGranted,
      beaconEnabled: event.beaconGranted
    );
  }

  void _checkPermissions() async {
    bool isInitial =  await _onboardRepository.isInitialLogin();
    if (isInitial != null && !isInitial) {
      List results = await Future.wait([
        flutterBeacon.bluetoothState,
        PermissionHandler().checkPermissionStatus(PermissionGroup.location),
        PermissionHandler().checkPermissionStatus(PermissionGroup.notification),
        PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways),
      ]);
      add(UpdateAllPermissions(
        bleGranted: results[0] == BluetoothState.stateOn,
        locationGranted: results[1] == PermissionStatus.granted,
        notificationGranted: results[2] == PermissionStatus.granted,
        beaconGranted: results[3] == PermissionStatus.granted
      ));
    }
  }
}