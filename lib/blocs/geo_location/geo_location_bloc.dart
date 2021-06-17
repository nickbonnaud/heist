import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/geolocator_repository.dart';

part 'geo_location_event.dart';
part 'geo_location_state.dart';

enum Accuracy {
  LOW,
  MEDIUM,
  HIGH,
  BEST
}

class GeoLocationBloc extends Bloc<GeoLocationEvent, GeoLocationState> {
  final GeolocatorRepository _geolocatorRepository;

  late StreamSubscription _permissionsBlocSubscription;
  
  GeoLocationBloc({required GeolocatorRepository geolocatorRepository, required PermissionsBloc permissionsBloc})
    : _geolocatorRepository = geolocatorRepository,
      super(Uninitialized()) {

        _permissionsBlocSubscription = permissionsBloc.stream.listen((PermissionsState state) { 
          if (!this.isGeoLocationReady && state.onStartPermissionsValid) {
            add(GeoLocationReady());
          }
        });
      }


  bool get isGeoLocationReady => state is LocationLoaded;

  Map<String, double>? get currentLocation {
    final currentState = state;
    if (currentState is LocationLoaded) {
      return {'lat': currentState.latitude, 'lng': currentState.longitude};
    }
    return null;
  }

  @override
  Stream<GeoLocationState> mapEventToState(GeoLocationEvent event) async* {
    if (event is GeoLocationReady) {
      yield* _mapAppReadyToState();
    } else if (event is FetchLocation) {
      yield* _mapFetchLocationToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _permissionsBlocSubscription.cancel();
    return super.close();
  }

  Stream<GeoLocationState> _mapAppReadyToState() async* {
    yield Loading();
    try {
      Position position = await _geolocatorRepository.fetchMed();
      yield LocationLoaded(latitude: position.latitude, longitude: position.longitude);
    } on TimeoutException catch (_) {
      yield FetchFailure();
    }
  }

  Stream<GeoLocationState> _mapFetchLocationToState({required FetchLocation event}) async* {
    yield Loading();
    try {
      Position position;
      switch (event.accuracy) {
        case Accuracy.LOW:
          position = await _geolocatorRepository.fetchLow();
          break;
        case Accuracy.MEDIUM:
          position = await _geolocatorRepository.fetchMed();
          break;
        case Accuracy.HIGH:
          position = await _geolocatorRepository.fetchHigh();
          break;
        case Accuracy.BEST:
          position = await _geolocatorRepository.fetchBest();
          break;
      }
      yield LocationLoaded(latitude: position.latitude, longitude: position.longitude);
    } on TimeoutException catch (_) {
      yield FetchFailure();
    }
  }
}
