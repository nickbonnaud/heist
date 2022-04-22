import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/repositories/initial_login_repository.dart';
import 'package:heist/resources/helpers/permissions_checker.dart';
import 'package:meta/meta.dart';

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
  final PermissionsChecker _permissionsChecker;

  PermissionsBloc({required InitialLoginRepository initialLoginRepository, required PermissionsChecker permissionsChecker})
    : _initialLoginRepository = initialLoginRepository,
      _permissionsChecker = permissionsChecker,
      super(PermissionsState.unknown()) { _eventHandler(); }

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

  void _eventHandler() {
    on<BleStatusChanged>((event, emit) => _mapBleStatusChangedToState(event: event, emit: emit));
    on<LocationStatusChanged>((event, emit) => _mapLocationStatusChangedToState(event: event, emit: emit));
    on<NotificationStatusChanged>((event, emit) => _mapNotificationStatusChangedToState(event: event, emit: emit));
    on<BeaconStatusChanged>((event, emit) => _mapBeaconStatusChangedToState(event: event, emit: emit));
    on<UpdateAllPermissions>((event, emit) => _mapUpdateAllPermissionsToState(event: event, emit: emit));
    on<IsInitialLogin>((event, emit) => _mapIsInitialLoginToState(emit: emit));
    on<CheckPermissions>((event, emit) async => await _checkPermissions(emit: emit));
  }

  void _mapBleStatusChangedToState({required BleStatusChanged event, required Emitter<PermissionsState> emit}) {
    emit(state.update(bleEnabled: event.granted));
  }

  void _mapLocationStatusChangedToState({required LocationStatusChanged event, required Emitter<PermissionsState> emit}) {
    emit(state.update(locationEnabled: event.granted));
  }

  void _mapNotificationStatusChangedToState({required NotificationStatusChanged event, required Emitter<PermissionsState> emit}) {
    emit(state.update(notificationEnabled: event.granted));
  }

  void _mapBeaconStatusChangedToState({required BeaconStatusChanged event, required Emitter<PermissionsState> emit}) {
    emit(state.update(beaconEnabled: event.granted));
  }

  void _mapUpdateAllPermissionsToState({required UpdateAllPermissions event, required Emitter<PermissionsState> emit}) {
    emit(state.update(
      bleEnabled: event.bleGranted,
      locationEnabled: event.locationGranted,
      notificationEnabled: event.notificationGranted,
      beaconEnabled: event.beaconGranted,
      checksComplete: event.checksComplete
    ));
  }

  void _mapIsInitialLoginToState({required Emitter<PermissionsState> emit}) {
    emit(PermissionsState.isInitial());
  }
  
  Future<void> _checkPermissions({required Emitter<PermissionsState> emit}) async {
    // TODO //
    // TEST CHANGE //
    
    bool isInitial =  await _initialLoginRepository.isInitialLogin();
    
    
    if (!isInitial) {
      // List results = await Future.wait([
      //   _permissionsChecker.bleEnabled(),
      //   _permissionsChecker.locationEnabled(),
      //   _permissionsChecker.notificationEnabled(),
      //   _permissionsChecker.beaconEnabled(),
      // ]);
      emit(state.update(
        bleEnabled: true,
        locationEnabled: true,
        notificationEnabled: true,
        beaconEnabled: true,
        checksComplete: true,
      ));
      // emit(state.update(
      //   bleEnabled: results[0],
      //   locationEnabled: results[1],
      //   notificationEnabled: results[2],
      //   beaconEnabled: results[3],
      //   checksComplete: true,
      // ));
    } else {
      add(IsInitialLogin());
    }
  }
}
