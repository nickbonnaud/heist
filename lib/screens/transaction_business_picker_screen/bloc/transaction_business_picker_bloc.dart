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
      
      _activeLocationsSubscription = activeLocationBloc.stream.listen((ActiveLocationState state) { 
        add(ActiveLocationsChanged(activeLocations: state.activeLocations));
      });
    }

  @override
  Stream<TransactionBusinessPickerState> mapEventToState(TransactionBusinessPickerEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState(event: event);
    } else if (event is ActiveLocationsChanged) {
      yield* _mapActiveLocationsChangedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _activeLocationsSubscription.cancel();
    return super.close();
  }

  Stream<TransactionBusinessPickerState> _mapInitToState({required Init event}) async* {
    List<Business> possibleBusinesses = _getAvailableBusinesses(activeLocations: event.activeLocations);
    
    yield state.update(availableBusinesses: possibleBusinesses);
  }
  
  Stream<TransactionBusinessPickerState> _mapActiveLocationsChangedToState({required ActiveLocationsChanged event}) async* {
    List<Business> possibleBusinesses = _getAvailableBusinesses(activeLocations: event.activeLocations);
    
    yield state.update(availableBusinesses: possibleBusinesses);
  }

  
  List<Business> _getAvailableBusinesses({required List<ActiveLocation> activeLocations}) {
    return activeLocations.where((activeLocation) => activeLocation.transactionIdentifier == null)
      .map((activeLocation) => activeLocation.business)
      .toList();
  }
}
