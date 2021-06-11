import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/icon_creator_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/home_screen/widgets/nearby_businesses_map/helpers/pre_marker.dart';

part 'nearby_businesses_event.dart';
part 'nearby_businesses_state.dart';

class NearbyBusinessesBloc extends Bloc<NearbyBusinessesEvent, NearbyBusinessesState> {
  final LocationRepository _locationRepository;
  final IconCreatorRepository _iconCreatorRepository;

  late StreamSubscription _geoLocationBlocSubscription;

  NearbyBusinessesBloc({
    required LocationRepository locationRepository,
    required IconCreatorRepository iconCreatorRepository,
    required GeoLocationBloc geoLocationBloc
  })
    : _locationRepository = locationRepository,
      _iconCreatorRepository = iconCreatorRepository,
      super(NearbyUninitialized()) {

        _geoLocationBlocSubscription = geoLocationBloc.stream.listen((GeoLocationState state) {
          if (state is LocationLoaded) {
            add(FetchNearby(lat: state.latitude, lng: state.longitude));
          }
        });
      }
  
  @override
  Stream<NearbyBusinessesState> mapEventToState(NearbyBusinessesEvent event) async* {
    if (event is FetchNearby) {
      yield* _mapFetchNearbyToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _geoLocationBlocSubscription.cancel();
    return super.close();
  }

  Stream<NearbyBusinessesState> _mapFetchNearbyToState({required FetchNearby event}) async* {
    try {
      final List<Business> businesses = await _locationRepository.sendLocation(
        lat: event.lat,
        lng: event.lng,
        startLocation: state is NearbyUninitialized
      );
      
      
      List<PreMarker> preMarkers = businesses.length > 0
        ? await _createPreMarkers(businesses)
        : [];
      
      yield NearbyBusinessLoaded(businesses: businesses, preMarkers: preMarkers);
    } on ApiException catch (exception) {
      yield FailedToLoadNearby(error: exception.error);
    }
  }

  Future<List<PreMarker>> _createPreMarkers(List<Business> businesses) async {
    return await _iconCreatorRepository.createPreMarkers(businesses: businesses);
  }
}
