import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:meta/meta.dart';

part 'active_location_event.dart';
part 'active_location_state.dart';

class ActiveLocationBloc extends Bloc<ActiveLocationEvent, ActiveLocationState> {
  final ActiveLocationRepository _activeLocationRepository;
  
  ActiveLocationBloc({@required ActiveLocationRepository activeLocationRepository})
    : assert(activeLocationRepository != null),
      _activeLocationRepository = activeLocationRepository,
      super(ActiveLocationState.initial());

  List<ActiveLocation> get locations => state.activeLocations;

  @override
  Stream<ActiveLocationState> mapEventToState(ActiveLocationEvent event) async* {
    if (event is NewActiveLocation) {
      yield* _mapNewActiveLocationToState(event);
    } else if (event is RemoveActiveLocation) {
      yield* _mapRemoveActiveLocationToState(event);
    } else if (event is ResetActiveLocations) {
      yield* _mapResetToState();
    }
  }

  Stream<ActiveLocationState> _mapNewActiveLocationToState(NewActiveLocation event) async* {
    if (state.activeLocations.indexWhere((activeLocation) => activeLocation.beaconIdentifier == event.beaconIdentifier) < 0) {
      try {
        ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beaconIdentifier: event.beaconIdentifier);
        final updatedActiveLocations = state
          .activeLocations
          .toList()
          ..add(activeLocation);
        yield state.update(activeLocations: updatedActiveLocations);
      } catch (e) {
        yield state.update(locationFailedToAdd: true);
      }
    }
  }

  Stream<ActiveLocationState> _mapRemoveActiveLocationToState(RemoveActiveLocation event) async* {
    final locationToRemove = state.activeLocations
      .firstWhere(
        (ActiveLocation location) => location.beaconIdentifier == event.beaconIdentifier, 
        orElse: null
      );
      if (locationToRemove != null) {
        try {
          bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
          if (didRemove) {
            final updatedActiveLocations = state
              .activeLocations
              .where((activeLocation) => activeLocation.beaconIdentifier != event.beaconIdentifier)
              .toList();
            
            yield state.update(activeLocations: updatedActiveLocations);
          } else {}
        } catch (e) {}
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
    state.update(locationFailedToAdd: false);
  }
}
