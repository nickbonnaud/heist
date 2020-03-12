import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:meta/meta.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocatorRepository _geolocatorRepository;

  GeolocationBloc({@required GeolocatorRepository geolocatorRepository})
    : assert(geolocatorRepository != null),
      _geolocatorRepository = geolocatorRepository;
  
  @override
  GeolocationState get initialState => Uninitialized();

  @override
  Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
    if (event is Uninitialized) {
      _mapUninitializedToState();
    } else if (event is CheckPermission) {
      yield* _mapCheckPermissionToState();
    } else if (event is AppReady) {
      yield* _mapAppReadyToState();
    } else if (event is FetchLocation) {
      yield* _mapFetchLocationToState();
    }
  }

  Stream<GeolocationState> _mapUninitializedToState() async* {
    yield PermissionUnknown();
  }

  Stream<GeolocationState> _mapCheckPermissionToState() async* {
    bool permissionGranted = await _geolocatorRepository.checkPermission();
    if (permissionGranted) {
      yield PermissionGranted();
    } else {
      yield PermissionDenied();
    }
  }
  
  Stream<GeolocationState> _mapAppReadyToState() async* {
    yield Loading();
    try {
      Position position = await _geolocatorRepository.fetchMed();
      yield LocationLoaded(latitude: position.latitude, longitude: position.longitude);
    } catch (_) {
      yield FetchFailure();
    }
  }

  Stream<GeolocationState> _mapFetchLocationToState() async* {
    yield Loading();
    try {
      Position position = await _geolocatorRepository.fetchHigh();
      yield LocationLoaded(latitude: position.latitude, longitude: position.longitude);
    } catch (_) {
      yield FetchFailure();
    }
  }
}
