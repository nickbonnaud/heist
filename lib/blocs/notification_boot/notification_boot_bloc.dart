import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:meta/meta.dart';

part 'notification_boot_event.dart';
part 'notification_boot_state.dart';

class NotificationBootBloc extends Bloc<NotificationBootEvent, NotificationBootState> {
  late StreamSubscription _permissionsBlocSubscription;
  late StreamSubscription _nearbyBusinessesBlocSubscription;
  late StreamSubscription _openTransactionsBlocSubscription;

  NotificationBootBloc({
    required PermissionsBloc permissionsBloc,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    required OpenTransactionsBloc openTransactionsBloc
  })  : super(NotificationBootState.initial()) {
        _eventHandler();
        
        _permissionsBlocSubscription = permissionsBloc.stream.listen((PermissionsState permissionsState) {
          if (!state.permissionReady && permissionsState.notificationEnabled) {
            add(PermissionReady());
          }
        });

        _nearbyBusinessesBlocSubscription = nearbyBusinessesBloc.stream.listen((NearbyBusinessesState nearbyBusinessesState) {
          if (nearbyBusinessesState is NearbyBusinessLoaded) {
            add(NearbyBusinessesReady());
          }
        });

        _openTransactionsBlocSubscription = openTransactionsBloc.stream.listen((OpenTransactionsState openTransactionsState) {
          if (openTransactionsState is OpenTransactionsLoaded) {
            add(OpenTransactionsReady());
          }
        });
  }

  void _eventHandler() {
    on<NearbyBusinessesReady>((event, emit) => _mapNearbyBusinessesReadyToState(emit: emit));
    on<OpenTransactionsReady>((event, emit) => _mapOpenTransactionsReadyToState(emit: emit));
    on<PermissionReady>((event, emit) => _mapPermissionReadyToState(emit: emit));
  }

  @override
  Future<void> close() {
    _permissionsBlocSubscription.cancel();
    _nearbyBusinessesBlocSubscription.cancel();
    _openTransactionsBlocSubscription.cancel();
    return super.close();
  }

  void _mapNearbyBusinessesReadyToState({required Emitter<NotificationBootState> emit}) {
    emit(state.update(nearbyBusinessesReady: true));
  }

  void _mapOpenTransactionsReadyToState({required Emitter<NotificationBootState> emit}) {
    emit(state.update(openTransactionsReady: true));
  }

  void _mapPermissionReadyToState({required Emitter<NotificationBootState> emit}) {
    emit(state.update(permissionReady: true));
  }
}
