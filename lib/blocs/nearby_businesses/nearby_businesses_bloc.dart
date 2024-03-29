import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/icon_creator_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/home_screen/widgets/home_screen_body/widgets/nearby_businesses_map/models/pre_marker.dart';

part 'nearby_businesses_event.dart';
part 'nearby_businesses_state.dart';

class NearbyBusinessesBloc extends Bloc<NearbyBusinessesEvent, NearbyBusinessesState> {
  final LocationRepository _locationRepository;
  final IconCreatorRepository _iconCreatorRepository;

  late StreamSubscription _geoLocationBlocSubscription;

  List<Business> get businesses => state.businesses;
  List<PreMarker> get preMarkers => (state as NearbyBusinessLoaded).preMarkers;
  
  NearbyBusinessesBloc({
    required LocationRepository locationRepository,
    required IconCreatorRepository iconCreatorRepository,
    required GeoLocationBloc geoLocationBloc
  })
    : _locationRepository = locationRepository,
      _iconCreatorRepository = iconCreatorRepository,
      super(NearbyUninitialized()) {

        _eventHandler();
        
        _geoLocationBlocSubscription = geoLocationBloc.stream.listen((GeoLocationState state) {
          if (state is LocationLoaded) {
            add(FetchNearby(lat: state.latitude, lng: state.longitude));
          }
        });
      }
  
  void _eventHandler() {
    on<FetchNearby>((event, emit) async => await _mapFetchNearbyToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _geoLocationBlocSubscription.cancel();
    return super.close();
  }

  Future<void> _mapFetchNearbyToState({required FetchNearby event, required Emitter<NearbyBusinessesState> emit}) async {
    emit(LoadingNearbyBusinesses());

    try {
      final List<Business> businesses = await _locationRepository.sendLocation(
        lat: event.lat,
        lng: event.lng,
        startLocation: state is NearbyUninitialized
      );
      
      
      List<PreMarker> preMarkers = businesses.isNotEmpty
        ? await _createPreMarkers(businesses)
        : [];
      
      emit(NearbyBusinessLoaded(businesses: businesses, preMarkers: preMarkers));
    } on ApiException catch (exception) {
      emit(FailedToLoadNearby(error: exception.error));
    }
  }

  Future<List<PreMarker>> _createPreMarkers(List<Business> businesses) async {
    return await _iconCreatorRepository.createPreMarkers(businesses: businesses);
  }
}
