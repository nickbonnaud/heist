import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/screens/map_screen/helpers/icon_creator.dart';
import 'package:heist/screens/map_screen/helpers/pre_marker.dart';

part 'map_screen_event.dart';
part 'map_screen_state.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  final LocationRepository locationRepository;

  MapScreenBloc({@required this.locationRepository})
    : assert(locationRepository != null);
  
  @override
  MapScreenState get initialState => MapScreenEmpty();

  @override
  Stream<MapScreenState> mapEventToState(MapScreenEvent event) async* {
    if (event is SendOnStartLocation) {
      yield* _mapSendOnStartLocationToState(event);
    } else if (event is SendLocation) {
      yield* _mapSendLocationToState(event);
    }
  }

  Stream<MapScreenState> _mapSendOnStartLocationToState(SendOnStartLocation event) async* {
    yield MarkersLoading();
    try {
      final List<Business> businesses = await locationRepository.sendLocation(
        lat: event.lat,
        lng: event.lng,
        startLocation: true
      );
      if (businesses.length == 0) {
        yield NoMarkers();
      } else {
        List<PreMarker> preMarkers = await _createPreMarkers(businesses);
        yield MarkersLoaded(businesses: businesses, preMarkers: preMarkers);
      }
    } catch (e) {
      yield FetchMarkersError();
    }
  }

  Stream<MapScreenState> _mapSendLocationToState(SendLocation event) async* {
    yield MarkersLoading();
    try {
      final List<Business> businesses = await locationRepository.sendLocation(
        lat: event.lat,
        lng: event.lng,
        startLocation: false
      );
      if (businesses.length == 0) {
        yield NoMarkers();
      } else {
        List<PreMarker> preMarkers = await _createPreMarkers(businesses);
        yield MarkersLoaded(businesses: businesses, preMarkers: preMarkers);
      }
    } catch (e) {
      yield FetchMarkersError();
    }
  }

  Future<List<PreMarker>> _createPreMarkers(List<Business> businesses) async {
    IconCreator iconCreator = IconCreator(size: Size(150, 150), businesses: businesses);
    return await iconCreator.createPreMarkers();
  }
}
