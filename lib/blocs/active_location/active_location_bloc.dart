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
      _activeLocationRepository = activeLocationRepository;
  
  @override
  ActiveLocationState get initialState => NoActiveLocations();

  @override
  Stream<ActiveLocationState> mapEventToState(ActiveLocationEvent event) async* {
    if (event is NewActiveLocation) {
      yield* _mapNewActiveLocationToState(event, state);
    } else if (event is RemoveActiveLocation) {
      yield* _mapRemoveActiveLocationToState(event, state);
    }
  }

  Stream<ActiveLocationState> _mapNewActiveLocationToState(NewActiveLocation event, ActiveLocationState state) async* {
    try {
      ActiveLocation activeLocation = await _activeLocationRepository.enterBusiness(beaconIdentifier: event.beaconIdentifier);
      if (state is CurrentActiveLocations) {
        List<ActiveLocation> activeLocations = state.activeLocations..add(activeLocation);
        yield CurrentActiveLocations(activeLocations: activeLocations);
      } else if (state is NoActiveLocations) {
        yield CurrentActiveLocations(activeLocations: [activeLocation].toList());
      }
    } catch (e) {
      yield SendActiveLocationFail(activeLocations: state is CurrentActiveLocations ? state.activeLocations : [].toList());
    }
  }

  Stream<ActiveLocationState> _mapRemoveActiveLocationToState(RemoveActiveLocation event, ActiveLocationState state) async* {
    if (state is CurrentActiveLocations) {
      List<ActiveLocation> activeLocations = state.activeLocations;
      ActiveLocation locationToRemove = activeLocations.firstWhere((ActiveLocation activeLocation) => activeLocation.beaconIdentifier == event.beaconIdentifier);
      try {
        bool didRemove = await _activeLocationRepository.exitBusiness(activeLocationId: locationToRemove.identifier);
        if (didRemove) {
          activeLocations = activeLocations..remove(locationToRemove);
          yield activeLocations.length == 0 ? NoActiveLocations() : CurrentActiveLocations(activeLocations: activeLocations);
        } else {
          yield CurrentActiveLocations(activeLocations: activeLocations);
        }
      } catch (e) {
        yield DeleteActiveLocationFail(activeLocations: state is CurrentActiveLocations ? state.activeLocations : [].toList());
      }
    }
  }
}
