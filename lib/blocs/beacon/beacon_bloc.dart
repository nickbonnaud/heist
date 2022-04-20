import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/beacon.dart' as business_beacon;
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/beacon_repository.dart';

part 'beacon_event.dart';
part 'beacon_state.dart';

class BeaconBloc extends Bloc<BeaconEvent, BeaconState> {
  final BeaconRepository _beaconRepository;
  final ActiveLocationBloc _activeLocationBloc;
  final bool _testing;

  late StreamSubscription _nearbyBusinessSubscription;
  StreamSubscription<MonitoringResult>? _beaconSubscription;

  BeaconBloc({
    required BeaconRepository beaconRepository,
    required ActiveLocationBloc activeLocationBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    bool testing = false
  })
    : _beaconRepository = beaconRepository,
      _activeLocationBloc = activeLocationBloc,
      _testing = testing,
      super(BeaconUninitialized()) {
        _eventHandler();
        
        _nearbyBusinessSubscription = nearbyBusinessesBloc.stream.listen((NearbyBusinessesState state) {
          if (state is NearbyBusinessLoaded) {
            add(StartBeaconMonitoring(businesses: state.businesses));

            if (_testing) {
              Business business = state.businesses.first;
              business_beacon.Beacon beacon = _regionToBeacon(region: Region(
                identifier: business.location.beacon.regionIdentifier,
                proximityUUID: business.location.beacon.proximityUUID,
                major: business.location.beacon.major,
                minor: business.location.beacon.minor
              )) ;
              add(Enter(beacon: beacon));

              business = state.businesses[1];
              beacon = _regionToBeacon(region: Region(
                identifier: business.location.beacon.regionIdentifier,
                proximityUUID: business.location.beacon.proximityUUID,
                major: business.location.beacon.major,
                minor: business.location.beacon.minor
              ));
              add(Enter(beacon: beacon));
            }
          }
        });
      }

  void _eventHandler() {
    on<StartBeaconMonitoring>((event, emit) => _mapStartBeaconMonitoringToState(event: event, emit: emit));
    on<BeaconCancelled>((event, emit) => _mapBeaconCancelledToState(emit: emit));
    on<Enter>((event, emit) => _mapEnterToState(event: event));
    on<Exit>((event, emit) => _mapExitToState(event: event));
  }

  @override
  Future<void> close() {
    _nearbyBusinessSubscription.cancel();
    _beaconSubscription?.cancel();
    return super.close();
  }

  void _mapStartBeaconMonitoringToState({required StartBeaconMonitoring event, required Emitter<BeaconState> emit}) {
    emit(LoadingBeacons());
    _beaconSubscription?.cancel();
    _beaconSubscription = _beaconRepository.startMonitoring(businesses: event.businesses).listen((MonitoringResult beaconEvent) {
      if (beaconEvent.monitoringEventType == MonitoringEventType.didEnterRegion) {
        add(Enter(beacon: _regionToBeacon(region: beaconEvent.region)));
      } else if (beaconEvent.monitoringEventType == MonitoringEventType.didExitRegion) {
        add(Exit(beacon: _regionToBeacon(region: beaconEvent.region)));
      }
    });
    emit(Monitoring());
  }

  void _mapBeaconCancelledToState({required Emitter<BeaconState> emit}) {
    _beaconSubscription?.cancel();
    emit(BeaconsCancelled());
  }

  void _mapEnterToState({required Enter event}) {
    _activeLocationBloc.add(NewActiveLocation(beacon: event.beacon));
  }

  void _mapExitToState({required Exit event}) {
    _activeLocationBloc.add(RemoveActiveLocation(beacon: event.beacon));
  }

  business_beacon.Beacon _regionToBeacon({required Region region}) {
    return business_beacon.Beacon(
      regionIdentifier: region.identifier,
      proximityUUID: region.proximityUUID!,
      major: region.major!,
      minor: region.minor!
    );
  }
}
