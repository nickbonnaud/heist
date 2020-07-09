import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notification_boot_event.dart';
part 'notification_boot_state.dart';

class NotificationBootBloc extends Bloc<NotificationBootEvent, NotificationBootState> {
  
  NotificationBootBloc() : super(NotificationBootState.initial());

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
}
