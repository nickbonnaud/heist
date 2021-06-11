import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/models/status.dart';
import 'package:meta/meta.dart';

part 'app_ready_event.dart';
part 'app_ready_state.dart';

enum DataType {
  transactions,
  businesses,
  beacons
}

class AppReadyBloc extends Bloc<AppReadyEvent, AppReadyState> {
  late StreamSubscription _authenticationBlocSubscription;
  late StreamSubscription _openTransactionsBlocSubscription;
  late StreamSubscription _beaconBlocSubscription;
  late StreamSubscription _nearbyBusinessesBlocSubscription;
  late StreamSubscription _permissionsBlocSubscription;
  late StreamSubscription _customerBlocSubscription;

  late AuthenticationState previousAuthenticationState;

  AppReadyBloc({
    required AuthenticationBloc authenticationBloc,
    required OpenTransactionsBloc openTransactionsBloc,
    required BeaconBloc beaconBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    required PermissionsBloc permissionsBloc,
    required CustomerBloc customerBloc
  })
    : super(AppReadyState.initial()) {
        
      _authenticationBlocSubscription = authenticationBloc.stream.listen((AuthenticationState authenticationState) {
        if (previousAuthenticationState is Unknown && (authenticationState is Unauthenticated || authenticationState is Authenticated)) {
          add(AuthCheckComplete(isAuthenticated: authenticationState is Authenticated));
          _authenticationBlocSubscription.cancel();
        }
        previousAuthenticationState = authenticationState;
      });

      _customerBlocSubscription = customerBloc.stream.listen((CustomerState customerState) {
        if (customerState.customer != null) {
          add(CustomerStatusChanged(customerStatus: customerState.customer!.status));
          _customerBlocSubscription.cancel();
        }
      });

      _openTransactionsBlocSubscription = openTransactionsBloc.stream.listen((OpenTransactionsState state) { 
        if (!this.areOpenTransactionsLoaded && (state is OpenTransactionsLoaded || state is FailedToFetchOpenTransactions)) {
          add(DataLoaded(type: DataType.transactions));
          _openTransactionsBlocSubscription.cancel();
        }
      });

      _beaconBlocSubscription = beaconBloc.stream.listen((BeaconState state) { 
        if (state is Monitoring && !this.areBeaconsLoaded) {
          add(DataLoaded(type: DataType.beacons));
          _beaconBlocSubscription.cancel();
        }
      });

      _nearbyBusinessesBlocSubscription = nearbyBusinessesBloc.stream.listen((NearbyBusinessesState state) {
        if (!this.areBusinessesLoaded && (state is NearbyBusinessLoaded || state is FailedToLoadNearby)) {
          add(DataLoaded(type: DataType.businesses));
          _nearbyBusinessesBlocSubscription.cancel();
        }
      });

      _permissionsBlocSubscription = permissionsBloc.stream.listen((PermissionsState state) {
        if (!this.arePermissionChecksComplete && state.checksComplete) {
          add(PermissionChecksComplete(permissionsReady: state.allPermissionsValid));
          _permissionsBlocSubscription.cancel();
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
  Stream<AppReadyState> mapEventToState(AppReadyEvent event) async* {
    if (event is CustomerStatusChanged) {
      yield* _mapCustomerStatusChangedToState(event: event);
    } else if (event is PermissionChecksComplete) {
      yield* _mapPermissionChecksCompleteToState(event: event);
    } else if (event is AuthCheckComplete) {
      yield* _mapAuthCheckCompleteToState(event: event);
    } else if (event is DataLoaded) {
      yield* _mapDataLoadedToState(event: event);
    }
  }

  @override
  Future<void> close() {
    _authenticationBlocSubscription.cancel();
    _openTransactionsBlocSubscription.cancel();
    _beaconBlocSubscription.cancel();
    _nearbyBusinessesBlocSubscription.cancel();
    _permissionsBlocSubscription.cancel();
    _customerBlocSubscription.cancel();
    return super.close();
  }

  Stream<AppReadyState> _mapCustomerStatusChangedToState({required CustomerStatusChanged event}) async* {
    yield state.update(customerOnboarded: event.customerStatus.code > 103);
  }

  Stream<AppReadyState> _mapPermissionChecksCompleteToState({required PermissionChecksComplete event}) async* {
    yield state.update(permissionChecksComplete: true, permissionsReady: event.permissionsReady);
  }

  Stream<AppReadyState>  _mapAuthCheckCompleteToState({required AuthCheckComplete event}) async* {
    yield state.update(authCheckComplete: true, isAuthenticated: event.isAuthenticated);
  }

  Stream<AppReadyState> _mapDataLoadedToState({required DataLoaded event}) async* {
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
