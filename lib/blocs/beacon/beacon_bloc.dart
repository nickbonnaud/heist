import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/beacon_repository.dart';

part 'beacon_event.dart';
part 'beacon_state.dart';

class BeaconBloc extends Bloc<BeaconEvent, BeaconState> {
  final BeaconRepository _beaconRepository;
  final ActiveLocationBloc _activeLocationBloc;

  late StreamSubscription _nearbyBusinessSubscription;
  StreamSubscription<MonitoringResult>? _beaconSubscription;

  BeaconBloc({
    required BeaconRepository beaconRepository,
    required ActiveLocationBloc activeLocationBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc
  })
    : _beaconRepository = beaconRepository,
      _activeLocationBloc = activeLocationBloc,
      super(BeaconUninitialized()) {

        _nearbyBusinessSubscription = nearbyBusinessesBloc.stream.listen((NearbyBusinessesState state) {
          if (state is NearbyBusinessLoaded) {
            add(StartBeaconMonitoring(businesses: state.businesses));

            // TEST CHANGE //

            // Business business = state.businesses.first;
            // add(Enter(region: Region(
            //   identifier: business.location.beacon.identifier,
            //   proximityUUID: business.location.beacon.identifier,
            //   major: business.location.beacon.major,
            //   minor: business.location.beacon.minor
            // )));

            Business business = state.businesses[1];
            add(Enter(region: Region(
              identifier: business.location.beacon.identifier,
              proximityUUID: business.location.beacon.identifier,
              major: business.location.beacon.major,
              minor: business.location.beacon.minor
            )));

            // Business business = state.businesses[2];
            // add(Enter(region: Region(
            //   identifier: business.location.beacon.identifier,
            //   proximityUUID: business.location.beacon.identifier,
            //   major: business.location.beacon.major,
            //   minor: business.location.beacon.minor
            // )));
          }
        });
      }

  @override
  Stream<BeaconState> mapEventToState(BeaconEvent event) async* {
    if (event is StartBeaconMonitoring) {
      yield* _mapStartBeaconMonitoringToState(event: event);
    } else if (event is BeaconCancelled) {
      yield* _mapBeaconCancelledToState();
    } else if (event is Enter) {
      yield* _mapEnterToState(event: event);
    } else if (event is Exit) {
      yield* _mapExitToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _nearbyBusinessSubscription.cancel();
    _beaconSubscription?.cancel();
    return super.close();
  }

  Stream<BeaconState> _mapStartBeaconMonitoringToState({required StartBeaconMonitoring event}) async* {
    yield LoadingBeacons();
    _beaconSubscription?.cancel();
    _beaconSubscription = _beaconRepository.startMonitoring(businesses: event.businesses).listen((MonitoringResult beaconEvent) {
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

  Stream<BeaconState> _mapEnterToState({required Enter event}) async* {
    _activeLocationBloc.add(NewActiveLocation(beaconIdentifier: event.region.proximityUUID ?? event.region.identifier));
  }

  Stream<BeaconState> _mapExitToState({required Exit event}) async* {
    _activeLocationBloc.add(RemoveActiveLocation(beaconIdentifier: event.region.proximityUUID ?? event.region.identifier));
  }
}
