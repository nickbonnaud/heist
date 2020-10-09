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
  StreamSubscription _permissionsBlocSubscription;
  StreamSubscription _nearbyBusinessesBlocSubscription;
  StreamSubscription _openTransactionsBlocSubscription;

  NotificationBootBloc({
    @required PermissionsBloc permissionsBloc,
    @required NearbyBusinessesBloc nearbyBusinessesBloc,
    @required OpenTransactionsBloc openTransactionsBloc
  })
    : assert(permissionsBloc != null && nearbyBusinessesBloc != null && openTransactionsBloc != null),
      super(NotificationBootState.initial()) {

        _permissionsBlocSubscription = permissionsBloc.listen((PermissionsState state) {
          if (!this.isPermissionReady && state.notificationEnabled) {
            add(PermissionReady());
          }
        });

        _nearbyBusinessesBlocSubscription = nearbyBusinessesBloc.listen((NearbyBusinessesState state) {
          if (state is NearbyBusinessLoaded) {
            add(NearbyBusinessesReady());
          }
        });

        _openTransactionsBlocSubscription = openTransactionsBloc.listen((OpenTransactionsState state) {
          if (state is OpenTransactionsLoaded) {
            add(OpenTransactionsReady());
          }
        });
      }
  
  bool get isPermissionReady => state.permissionReady;

  @override
  Stream<NotificationBootState> mapEventToState(NotificationBootEvent event) async* {
    if (event is NearbyBusinessesReady) {
      yield state.update(nearbyBusinessesReady: true);
    } else if (event is OpenTransactionsReady) {
      yield state.update(openTransactionsReady: true);
    } else if (event is PermissionReady) {
      yield state.update(permissionReady: true);
    }
  }

  @override
  Future<void> close() {
    _permissionsBlocSubscription.cancel();
    _nearbyBusinessesBlocSubscription.cancel();
    _openTransactionsBlocSubscription.cancel();
    return super.close();
  }
}
