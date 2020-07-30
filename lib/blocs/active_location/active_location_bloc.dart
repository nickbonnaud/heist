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
      super(NoActiveLocations());

  List<ActiveLocation> get locations => state.locations;

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
    final currentState = state;
    if (currentState is CurrentActiveLocations) {
      if (currentState.activeLocations.indexWhere((activeLocation) => activeLocation.beaconIdentifier == event.beaconIdentifier) < 0) {
        try {
          ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beaconIdentifier: event.beaconIdentifier);
          final updatedActiveLocations = currentState
            .activeLocations
            .toList()
            ..add(activeLocation);
          yield currentState.update(activeLocations: updatedActiveLocations);
        } catch (e) {
          yield currentState.update(addActiveLocationFail: true);
        }
      }
    } else if (currentState is NoActiveLocations) {
      try {
        ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beaconIdentifier: event.beaconIdentifier);
        final updatedActiveLocations = []
          .toList()
          ..add(activeLocation);
        yield CurrentActiveLocations(activeLocations: updatedActiveLocations);
      } catch (e) {
        yield currentState.update(addActiveLocationFail: true);
      }
    }
  }

  Stream<ActiveLocationState> _mapRemoveActiveLocationToState(RemoveActiveLocation event) async* {
    final currentState = state;
    if (currentState is CurrentActiveLocations) {
      try {
        final locationToRemove = currentState.activeLocations
          .firstWhere((ActiveLocation location) => location.beaconIdentifier == event.beaconIdentifier, 
          orElse: null);
        if (locationToRemove != null) {
          bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
          if (didRemove) {
            final updatedActiveLocations = currentState
              .activeLocations
              .where((activeLocation) => activeLocation.beaconIdentifier != event.beaconIdentifier)
              .toList();
            
            yield updatedActiveLocations.length == 0
              ? NoActiveLocations()
              : currentState.update(activeLocations: updatedActiveLocations);
          } else {
            yield currentState.update(removeActiveLocationFail: true);
          }
        }
      } catch (e) {
        yield currentState.update(removeActiveLocationFail: true);
      }
    }
  }

  Stream<ActiveLocationState> _mapResetToState() async* {
    final currentState = state;
    if (currentState is CurrentActiveLocations) {
      yield currentState.update(addActiveLocationFail: false, removeActiveLocationFail: false);
    } else if (currentState is NoActiveLocations) {
      yield currentState.update(addActiveLocationFail: false, removeActiveLocationFail: false);
    }
  }
}
