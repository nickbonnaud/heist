import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  @override
  PermissionsState get initialState => PermissionsState.uninitialized();

  @override
  Stream<PermissionsState> mapEventToState(PermissionsEvent event) async* {
    if (event is AppReady) {
      yield* _mapAppReadyToState();
    } else if (event is LocationPermissionUpdated) {
      yield* _mapLocationPermissionUpdatedToState(event.isLocationEnabled);
    } else if (event is NotificationPermissionUpdated) {
      yield* _mapNotificationPermissionUpdatedToState(event.isNotificationEnabled);
    } else if (event is BeaconPermissionUpdated) {
      yield* _mapBeaconPermissionUpdatedToState(event.isBeaconEnabled);
    } else if (event is UpdateAllPermissions) {
      yield* _mapUpdateAllPermissionsToState(event.isLocationEnabled, event.isNotificationEnabled, event.isBeaconEnabled);
    }
  }

  Stream<PermissionsState> _mapAppReadyToState() async* {
    PermissionStatus locationStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
    PermissionStatus notificationStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.notification);
    yield state.update(isLocationEnabled: locationStatus == PermissionStatus.granted, isNotificationEnabled: notificationStatus == PermissionStatus.granted);
  }

  Stream<PermissionsState> _mapLocationPermissionUpdatedToState(bool isLocationEnabled) async* {
    yield state.update(isLocationEnabled: isLocationEnabled);
  }

  Stream<PermissionsState> _mapNotificationPermissionUpdatedToState(bool isNotificationEnabled) async* {
    yield state.update(isNotificationEnabled: isNotificationEnabled);
  }

  Stream<PermissionsState> _mapBeaconPermissionUpdatedToState(bool isBeaconEnabled) async* {
    yield state.update(isBeaconEnabled: isBeaconEnabled);
  }

  Stream<PermissionsState> _mapUpdateAllPermissionsToState(bool isLocationEnabled, bool isNotificationEnabled, bool isBeaconEnabled) async* {
    yield state.update(isLocationEnabled: isLocationEnabled, isNotificationEnabled: isNotificationEnabled, isBeaconEnabled: isBeaconEnabled);
  }
}
