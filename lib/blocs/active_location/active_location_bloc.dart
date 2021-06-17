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
      yield state.update(addingLocations: state.addingLocations + [event.beaconIdentifier]);
      try {
        ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beaconIdentifier: event.beaconIdentifier);
        yield state.update(
          activeLocations: state.activeLocations + [activeLocation],
          addingLocations: state.addingLocations.where((beaconIdentifier) => beaconIdentifier != event.beaconIdentifier).toList()
        );
      } on ApiException catch (exception) {
        yield state.update(
          errorMessage: exception.error,
          addingLocations: state.addingLocations.where((beaconIdentifier) => beaconIdentifier != event.beaconIdentifier).toList()
        );
      }
    }
  }

  Stream<ActiveLocationState> _mapRemoveActiveLocationToState({required RemoveActiveLocation event}) async* {
    final ActiveLocation? locationToRemove = state.activeLocations
      .firstWhereOrNull((ActiveLocation location) => location.beaconIdentifier == event.beaconIdentifier);
    if (locationToRemove != null && !state.removingLocations.contains(event.beaconIdentifier)) {
      yield state.update(removingLocations: state.removingLocations + [event.beaconIdentifier]);
      try {
        bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
        if (didRemove) {
          final updatedActiveLocations = state
            .activeLocations
            .where((activeLocation) => activeLocation.beaconIdentifier != event.beaconIdentifier)
            .toList();
          
          yield state.update(
            activeLocations: updatedActiveLocations, 
            removingLocations: state.removingLocations.where((beaconIdentifier) => beaconIdentifier != event.beaconIdentifier).toList());
        } else {
          yield state.update(
            errorMessage: "Unable to remove active location.",
            removingLocations: state.removingLocations.where((beaconIdentifier) => beaconIdentifier != event.beaconIdentifier).toList());
        }
      } on ApiException catch (exception) {
        yield state.update(
          errorMessage: exception.error,
          removingLocations: state.removingLocations.where((beaconIdentifier) => beaconIdentifier != event.beaconIdentifier).toList());
      }
    }
  }

  Stream<ActiveLocationState> _mapResetToState() async* {
    yield state.update(errorMessage: "");
  }
}
