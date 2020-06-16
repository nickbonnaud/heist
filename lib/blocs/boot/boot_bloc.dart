import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/status.dart';
import 'package:meta/meta.dart';

part 'boot_event.dart';
part 'boot_state.dart';

enum DataType {
  transactions,
  businesses,
  beacons
}

class BootBloc extends Bloc<BootEvent, BootState> {
  @override
  BootState get initialState => BootState.initial();

  bool get isDataLoaded => state.isDataLoaded;

  @override
  Stream<BootState> mapEventToState(BootEvent event) async* {
    if (event is CustomerStatusChanged) {
      yield* _mapCustomerStatusChangedToState(event);
    } else if (event is PermissionChecksComplete) {
      yield* _mapPermissionChecksCompleteToState();
    } else if (event is DataLoaded) {
      yield* _mapDataLoadedToState(event);
    }
  }

  Stream<BootState> _mapCustomerStatusChangedToState(CustomerStatusChanged event) async* {
    yield state.update(customerOnboarded: event.customerStatus.code > 103);
  }

  Stream<BootState> _mapPermissionChecksCompleteToState() async* {
    yield state.update(checksComplete: true);
  }

  Stream<BootState> _mapDataLoadedToState(DataLoaded event) async* {
    switch (event.type) {
      case DataType.transactions:
        yield state.update(openTransactionsLoaded: true);
        break;
      case DataType.businesses:
        yield state.update(nearbyBusinessesLoaded: true);
        break;
      case DataType.beacons:
        yield state.update(beaconsLoaded: true);
        break;
    }
  }
}
