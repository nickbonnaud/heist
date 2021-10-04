import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';

part 'transaction_business_picker_event.dart';
part 'transaction_business_picker_state.dart';

class TransactionBusinessPickerBloc extends Bloc<TransactionBusinessPickerEvent, TransactionBusinessPickerState> {
  late StreamSubscription _activeLocationsSubscription;
  
  TransactionBusinessPickerBloc({required ActiveLocationBloc activeLocationBloc})
    : super(TransactionBusinessPickerState.initial()) {
      
      _eventHandler();
      
      _activeLocationsSubscription = activeLocationBloc.stream.listen((ActiveLocationState state) { 
        add(ActiveLocationsChanged(activeLocations: state.activeLocations));
      });
    }

  void _eventHandler() {
    on<Init>((event, emit) => _mapInitToState(event: event, emit: emit));
    on<ActiveLocationsChanged>((event, emit) => _mapActiveLocationsChangedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _activeLocationsSubscription.cancel();
    return super.close();
  }

  void _mapInitToState({required Init event, required Emitter<TransactionBusinessPickerState> emit}) async {
    List<Business> possibleBusinesses = _getAvailableBusinesses(activeLocations: event.activeLocations);
    emit(state.update(availableBusinesses: possibleBusinesses));
  }
  
  void _mapActiveLocationsChangedToState({required ActiveLocationsChanged event, required Emitter<TransactionBusinessPickerState> emit}) async {
    List<Business> possibleBusinesses = _getAvailableBusinesses(activeLocations: event.activeLocations);
    emit(state.update(availableBusinesses: possibleBusinesses));
  }

  
  List<Business> _getAvailableBusinesses({required List<ActiveLocation> activeLocations}) {
    return activeLocations.where((activeLocation) => activeLocation.transactionIdentifier == null)
      .map((activeLocation) => activeLocation.business)
      .toList();
  }
}
