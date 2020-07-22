import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';

part 'google_map_screen_event.dart';
part 'google_map_screen_state.dart';

class GoogleMapScreenBloc extends Bloc<GoogleMapScreenEvent, GoogleMapScreenState> {
  GoogleMapScreenBloc() : super(GoogleMapScreenState.initial());

  @override
  Stream<GoogleMapScreenState> mapEventToState(GoogleMapScreenEvent event) async* {
    if (event is Tapped) {
      yield GoogleMapScreenState(screenCoordinate: event.screenCoordinate, business: event.business);
    } else if (event is Reset) {
      yield GoogleMapScreenState.initial();
    }
  }
}
