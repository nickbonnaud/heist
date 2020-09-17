import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/resources/helpers/icon_creator.dart';
import 'package:heist/screens/home_screen/widgets/nearby_businesses_map/helpers/pre_marker.dart';
import 'package:meta/meta.dart';

part 'nearby_businesses_event.dart';
part 'nearby_businesses_state.dart';

class NearbyBusinessesBloc extends Bloc<NearbyBusinessesEvent, NearbyBusinessesState> {
  final LocationRepository _locationRepository;
  final BootBloc _bootBloc;

  NearbyBusinessesBloc({@required LocationRepository locationRepository, @required BootBloc bootBloc})
    : assert(locationRepository != null && bootBloc != null),
      _locationRepository = locationRepository,
      _bootBloc = bootBloc,
      super(NearbyUninitialized());

  List<Business> get businesses => state.businesses;
  
  @override
  Stream<NearbyBusinessesState> mapEventToState(NearbyBusinessesEvent event) async* {
    if (event is FetchNearby) {
      yield* _mapFetchNearbyToState(event);
    }
  }

  Stream<NearbyBusinessesState> _mapFetchNearbyToState(FetchNearby event) async* {
    try {
      final List<Business> businesses = await _locationRepository.sendLocation(
        lat: event.lat,
        lng: event.lng,
        startLocation: state is NearbyUninitialized
      );
      
      
      List<PreMarker> preMarkers = businesses.length > 0
        ? await _createPreMarkers(businesses)
        : null;
      
      yield NearbyBusinessLoaded(businesses: businesses, preMarkers: preMarkers);
      _updateBootBloc();
    } catch (e) {
      yield FailedToLoadNearby();
      _updateBootBloc();
    }
  }

  Future<List<PreMarker>> _createPreMarkers(List<Business> businesses) async {
    IconCreator iconCreator = IconCreator(size: Size(150, 150), businesses: businesses);
    return await iconCreator.createPreMarkers();
  }

  void _updateBootBloc() {
    if (!_bootBloc.areBusinessesLoaded) _bootBloc.add(DataLoaded(type: DataType.businesses));
  }
}
