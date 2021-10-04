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

  AppReadyBloc({
    required AuthenticationBloc authenticationBloc,
    required OpenTransactionsBloc openTransactionsBloc,
    required BeaconBloc beaconBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    required PermissionsBloc permissionsBloc,
    required CustomerBloc customerBloc
  })
    : super(AppReadyState.initial()) {
        
      _eventHandler();
      
      _authenticationBlocSubscription = authenticationBloc.stream.listen((AuthenticationState authenticationState) {
        if (authenticationState is !Unknown && !state.authCheckComplete) {
          add(AuthCheckComplete(isAuthenticated: authenticationState is Authenticated));
          _authenticationBlocSubscription.cancel();
        }
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
        if (!this.areBeaconsLoaded && state is Monitoring) {
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

  void _eventHandler() {
    on<CustomerStatusChanged>((event, emit) => _mapCustomerStatusChangedToState(event: event, emit: emit));
    on<PermissionChecksComplete>((event, emit) => _mapPermissionChecksCompleteToState(event: event, emit: emit));
    on<AuthCheckComplete>((event, emit) => _mapAuthCheckCompleteToState(event: event, emit: emit));
    on<DataLoaded>((event, emit) => _mapDataLoadedToState(event: event, emit: emit));
  }
  
  bool get isDataLoaded => state.isDataLoaded;
  bool get arePermissionChecksComplete => state.permissionChecksComplete;
  bool get arePermissionsReady => state.permissionsReady;
  bool get areBusinessesLoaded => state.areBusinessesLoaded;
  bool get areBeaconsLoaded => state.areBeaconsLoaded;
  bool get areOpenTransactionsLoaded => state.areOpenTransactionsLoaded;
  bool get isCustomerOnboarded => state.customerOnboarded;

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

  void _mapCustomerStatusChangedToState({required CustomerStatusChanged event, required Emitter<AppReadyState> emit}) async {
    emit(state.update(customerOnboarded: event.customerStatus.code > 103));
  }

  void _mapPermissionChecksCompleteToState({required PermissionChecksComplete event, required Emitter<AppReadyState> emit}) async {
    emit(state.update(permissionChecksComplete: true, permissionsReady: event.permissionsReady));
  }

  void _mapAuthCheckCompleteToState({required AuthCheckComplete event, required Emitter<AppReadyState> emit}) async {
    emit(state.update(authCheckComplete: true, isAuthenticated: event.isAuthenticated));
  }

  void _mapDataLoadedToState({required DataLoaded event, required Emitter<AppReadyState> emit}) async {
    switch (event.type) {
      case DataType.transactions:
        emit(state.update(openTransactionsLoaded: true));
        break;
      case DataType.businesses:
        emit(state.update(nearbyBusinessesLoaded: true));
        break;
      case DataType.beacons:
        emit(state.update(beaconsLoaded: true));
        break;
    }
  }
}
