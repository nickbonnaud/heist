import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

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
  StreamSubscription _authenticationBlocSubscription;
  StreamSubscription _openTransactionsBlocSubscription;
  StreamSubscription _beaconBlocSubscription;
  StreamSubscription _nearbyBusinessesBlocSubscription;
  StreamSubscription _permissionsBlocSubscription;

  BootBloc({
    @required AuthenticationBloc authenticationBloc,
    @required OpenTransactionsBloc openTransactionsBloc,
    @required BeaconBloc beaconBloc,
    @required NearbyBusinessesBloc nearbyBusinessesBloc,
    @required PermissionsBloc permissionsBloc
  })
    : assert(
      authenticationBloc != null &&
      openTransactionsBloc != null &&
      beaconBloc != null &&
      nearbyBusinessesBloc != null &&
      permissionsBloc != null
    ),
      super(BootState.initial()) {
        
        _authenticationBlocSubscription = authenticationBloc.listen((AuthenticationState state) {
          if (state.authenticated) {
            add(CustomerStatusChanged(customerStatus: authenticationBloc.customer.status));
          }

          if (state.authCheckComplete) {
            add(AuthCheckComplete(isAuthenticated: authenticationBloc.isAuthenticated));
          }
        });

        _openTransactionsBlocSubscription = openTransactionsBloc.listen((OpenTransactionsState state) { 
          if (!this.areOpenTransactionsLoaded && (state is OpenTransactionsLoaded || state is FailedToFetchOpenTransactions)) {
            add(DataLoaded(type: DataType.transactions));
          }
        });

        _beaconBlocSubscription = beaconBloc.listen((BeaconState state) { 
          if (state is Monitoring && !this.areBeaconsLoaded) {
            add(DataLoaded(type: DataType.beacons));
          }
        });

        _nearbyBusinessesBlocSubscription = nearbyBusinessesBloc.listen((NearbyBusinessesState state) {
          if (!this.areBusinessesLoaded && (state is NearbyBusinessLoaded || state is FailedToLoadNearby)) {
            add(DataLoaded(type: DataType.businesses));
          }
        });

        _permissionsBlocSubscription = permissionsBloc.listen((PermissionsState state) {
          if (!this.arePermissionChecksComplete && state.checksComplete) {
            add(PermissionChecksComplete(permissionsReady: state.allPermissionsValid));
          }

        });
      }
      

  bool get isDataLoaded => state.isDataLoaded;
  bool get arePermissionChecksComplete => state.permissionChecksComplete;
  bool get arePermissionsReady => state.permissionsReady;
  bool get areBusinessesLoaded => state.areBusinessesLoaded;
  bool get areBeaconsLoaded => state.areBeaconsLoaded;
  bool get areOpenTransactionsLoaded => state.areOpenTransactionsLoaded;
  bool get isCustomerOnboarded => state.customerOnboarded;

  @override
  Stream<BootState> mapEventToState(BootEvent event) async* {
    if (event is CustomerStatusChanged) {
      yield* _mapCustomerStatusChangedToState(event: event);
    } else if (event is PermissionChecksComplete) {
      yield* _mapPermissionChecksCompleteToState(event: event);
    } else if (event is AuthCheckComplete) {
      yield* _mapAuthCheckCompleteToState(event: event);
    } else if (event is DataLoaded) {
      yield* _mapDataLoadedToState(event);
    }
  }

  @override
  Future<void> close() {
    _authenticationBlocSubscription.cancel();
    _openTransactionsBlocSubscription.cancel();
    _beaconBlocSubscription.cancel();
    _nearbyBusinessesBlocSubscription.cancel();
    _permissionsBlocSubscription.cancel();
    return super.close();
  }

  Stream<BootState> _mapCustomerStatusChangedToState({@required CustomerStatusChanged event}) async* {
    yield state.update(customerOnboarded: event.customerStatus.code > 103);
  }

  Stream<BootState> _mapPermissionChecksCompleteToState({@required PermissionChecksComplete event}) async* {
    yield state.update(permissionChecksComplete: true, permissionsReady: event.permissionsReady);
  }

  Stream<BootState>  _mapAuthCheckCompleteToState({@required AuthCheckComplete event}) async* {
    yield state.update(authCheckComplete: true, isAuthenticated: event.isAuthenticated);
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
