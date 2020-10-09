import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/beacon_repository.dart';
import 'package:meta/meta.dart';

part 'beacon_event.dart';
part 'beacon_state.dart';

class BeaconBloc extends Bloc<BeaconEvent, BeaconState> {
  final BeaconRepository _beaconRepository;
  final ActiveLocationBloc _activeLocationBloc;

  StreamSubscription _nearbyBusinessSubscription;
  StreamSubscription<MonitoringResult> _beaconSubscription;

  BeaconBloc({
    @required BeaconRepository beaconRepository,
    @required ActiveLocationBloc activeLocationBloc,
    @required NearbyBusinessesBloc nearbyBusinessesBloc
  })
    : assert(beaconRepository != null && activeLocationBloc != null && nearbyBusinessesBloc != null),
      _beaconRepository = beaconRepository,
      _activeLocationBloc = activeLocationBloc,
      super(BeaconUninitialized()) {

        _nearbyBusinessSubscription = nearbyBusinessesBloc.listen((NearbyBusinessesState state) {
          if (state is NearbyBusinessLoaded) {
            add(StartBeaconMonitoring(businesses: state.businesses));
          }
        });
      }

  @override
  Stream<BeaconState> mapEventToState(BeaconEvent event) async* {
    if (event is StartBeaconMonitoring) {
      yield* _mapStartBeaconMonitoringToState(event);
    } else if (event is BeaconCancelled) {
      yield* _mapBeaconCancelledToState();
    } else if (event is Enter) {
      yield* _mapEnterToState(event);
    } else if (event is Exit) {
      yield* _mapExitToState(event);
    }
  }

  @override
  Future<void> close() {
    _nearbyBusinessSubscription.cancel();
    return super.close();
  }

  Stream<BeaconState> _mapStartBeaconMonitoringToState(StartBeaconMonitoring event) async* {
    yield LoadingBeacons();
    _beaconSubscription?.cancel();
    _beaconSubscription = _beaconRepository.startMonitoring(event.businesses).listen((MonitoringResult beaconEvent) {
      if (beaconEvent.monitoringEventType == MonitoringEventType.didEnterRegion) {
        add(Enter(region: beaconEvent.region));
      } else if (beaconEvent.monitoringEventType == MonitoringEventType.didExitRegion) {
        add(Exit(region: beaconEvent.region));
      }
    });
    yield Monitoring();
  }

  Stream<BeaconState> _mapBeaconCancelledToState() async* {
    _beaconSubscription?.cancel();
    yield BeaconsCancelled();
  }

  Stream<BeaconState> _mapEnterToState(Enter event) async* {
    _activeLocationBloc.add(NewActiveLocation(beaconIdentifier: event.region.proximityUUID));
  }

  Stream<BeaconState> _mapExitToState(Exit event) async* {
    _activeLocationBloc.add(RemoveActiveLocation(beaconIdentifier: event.region.proximityUUID));
  }
}
