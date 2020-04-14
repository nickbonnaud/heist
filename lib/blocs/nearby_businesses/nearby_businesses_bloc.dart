import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/resources/helpers/icon_creator.dart';
import 'package:heist/screens/map_screen/helpers/pre_marker.dart';
import 'package:meta/meta.dart';

part 'nearby_businesses_event.dart';
part 'nearby_businesses_state.dart';

class NearbyBusinessesBloc extends Bloc<NearbyBusinessesEvent, NearbyBusinessesState> {
  final LocationRepository _locationRepository;

  NearbyBusinessesBloc({@required LocationRepository locationRepository})
    : assert(locationRepository != null),
      _locationRepository = locationRepository;
  
  @override
  NearbyBusinessesState get initialState => NearbyUninitialized();

  @override
  Stream<NearbyBusinessesState> mapEventToState(NearbyBusinessesEvent event) async* {
    if (event is FetchNearby) {
      yield* _mapFetchNearbyToState(event);
    }
  }

  Stream<NearbyBusinessesState> _mapFetchNearbyToState(FetchNearby event) async* {
    try {
      bool isInitial = state is NearbyUninitialized;
      final List<Business> businesses = await _locationRepository.sendLocation(lat: event.lat, lng: event.lng, startLocation: isInitial);
      if (businesses.length == 0) {
        yield NoNearby();
      } else {
        List<PreMarker> preMarkers = await _createPreMarkers(businesses);
        yield NearbyBusinessLoaded(businesses: businesses, preMarkers: preMarkers);
      }
    } catch (e) {
      FailedToLoadNearby();
    }
  }


  Future<List<PreMarker>> _createPreMarkers(List<Business> businesses) async {
    IconCreator iconCreator = IconCreator(size: Size(150, 150), businesses: businesses);
    return await iconCreator.createPreMarkers();
  }
}
