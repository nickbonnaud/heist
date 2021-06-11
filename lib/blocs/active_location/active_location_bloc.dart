import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:meta/meta.dart';

part 'active_location_event.dart';
part 'active_location_state.dart';

class ActiveLocationBloc extends Bloc<ActiveLocationEvent, ActiveLocationState> {
  final ActiveLocationRepository _activeLocationRepository;
  
  ActiveLocationBloc({required ActiveLocationRepository activeLocationRepository})
    : _activeLocationRepository = activeLocationRepository,
      super(ActiveLocationState.initial());

  @override
  Stream<ActiveLocationState> mapEventToState(ActiveLocationEvent event) async* {
    if (event is NewActiveLocation) {
      yield* _mapNewActiveLocationToState(event: event);
    } else if (event is RemoveActiveLocation) {
      yield* _mapRemoveActiveLocationToState(event: event);
    } else if (event is ResetActiveLocations) {
      yield* _mapResetToState();
    }
  }

  Stream<ActiveLocationState> _mapNewActiveLocationToState({required NewActiveLocation event}) async* {
    if (!state.activeLocations.any((activeLocation) => activeLocation.beaconIdentifier == event.beaconIdentifier) && !state.addingLocations.contains(event.beaconIdentifier)) {
      
      yield state.update(addingLocations: state.addingLocations..add(event.beaconIdentifier));
      try {
        ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beaconIdentifier: event.beaconIdentifier);
        yield state.update(activeLocations: state.activeLocations..add(activeLocation), addingLocations: state.addingLocations..remove(event.beaconIdentifier));
      } on ApiException catch (exception) {
        yield state.update(errorMessage: exception.error, addingLocations: state.addingLocations..remove(event.beaconIdentifier));
      }
    }
  }

  Stream<ActiveLocationState> _mapRemoveActiveLocationToState({required RemoveActiveLocation event}) async* {
    final ActiveLocation? locationToRemove = state.activeLocations
      .firstWhereOrNull((ActiveLocation location) => location.beaconIdentifier == event.beaconIdentifier);
    
    if (locationToRemove != null && !state.removingLocations.contains(event.beaconIdentifier)) {
      
      yield state.update(removingLocations: state.removingLocations..add(event.beaconIdentifier));
      try {
        bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
        if (didRemove) {
          final updatedActiveLocations = state
            .activeLocations
            .where((activeLocation) => activeLocation.beaconIdentifier != event.beaconIdentifier)
            .toList();
          
          yield state.update(activeLocations: updatedActiveLocations, removingLocations: state.removingLocations..remove(event.beaconIdentifier));
        } else {
          state.update(errorMessage: "Unable to remove active location.", removingLocations: state.removingLocations..remove(event.beaconIdentifier));
        }
      } on ApiException catch (exception) {
        yield state.update(errorMessage: exception.error, removingLocations: state.removingLocations..remove(event.beaconIdentifier));
      }
    }
    
    // final currentState = state;
    // if (currentState is CurrentActiveLocations) {
    //   try {
    //     final locationToRemove = currentState.activeLocations
    //       .firstWhere((ActiveLocation location) => location.beaconIdentifier == event.beaconIdentifier, 
    //       orElse: null);
    //     if (locationToRemove != null) {
    //       bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
    //       if (didRemove) {
    //         final updatedActiveLocations = currentState
    //           .activeLocations
    //           .where((activeLocation) => activeLocation.beaconIdentifier != event.beaconIdentifier)
    //           .toList();
            
    //         yield updatedActiveLocations.length == 0
    //           ? NoActiveLocations()
    //           : currentState.update(activeLocations: updatedActiveLocations);
    //       } else {
    //         yield currentState.update(removeActiveLocationFail: true);
    //       }
    //     }
    //   } catch (e) {
    //     yield currentState.update(removeActiveLocationFail: true);
    //   }
    // }
  }

  Stream<ActiveLocationState> _mapResetToState() async* {
    state.update(errorMessage: "");
  }
}
