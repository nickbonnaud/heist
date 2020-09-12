import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:meta/meta.dart';

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

  bool get isGeoLocationReady => state is LocationLoaded;
  
  GeoLocationBloc({@required GeolocatorRepository geolocatorRepository})
    : assert(geolocatorRepository != null),
      _geolocatorRepository = geolocatorRepository,
      super(Uninitialized());

  @override
  Stream<GeoLocationState> mapEventToState(GeoLocationEvent event) async* {
    if (event is GeoLocationReady) {
      yield* _mapAppReadyToState();
    } else if (event is FetchLocation) {
      yield* _mapFetchLocationToState(event);
    }
  }

  Stream<GeoLocationState> _mapAppReadyToState() async* {
    yield Loading();
    try {
      Position position = await _geolocatorRepository.fetchMed();
      yield LocationLoaded(latitude: position.latitude, longitude: position.longitude);
    } catch (_) {
      yield FetchFailure();
    }
  }

  Stream<GeoLocationState> _mapFetchLocationToState(FetchLocation event) async* {
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
    } catch (_) {
      yield FetchFailure();
    }
  }
}
