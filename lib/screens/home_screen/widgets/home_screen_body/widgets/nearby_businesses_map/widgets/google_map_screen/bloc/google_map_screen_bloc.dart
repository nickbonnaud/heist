import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';

part 'google_map_screen_event.dart';
part 'google_map_screen_state.dart';

class GoogleMapScreenBloc extends Bloc<GoogleMapScreenEvent, GoogleMapScreenState> {
  GoogleMapScreenBloc()
    : super(GoogleMapScreenState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Tapped>((event, emit) => _mapTappedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapTappedToState({required Tapped event, required Emitter<GoogleMapScreenState> emit}) {
    emit(GoogleMapScreenState(screenCoordinate: event.screenCoordinate, business: event.business));
  }

  void _mapResetToState({required Emitter<GoogleMapScreenState> emit}) {
    emit(GoogleMapScreenState.initial());
  }
}
