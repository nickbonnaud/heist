import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'notification_navigation_event.dart';
part 'notification_navigation_state.dart';

class NotificationNavigationBloc extends Bloc<NotificationNavigationEvent, NotificationNavigationState> {
  NotificationNavigationBloc() : super(NotificationNavigationState.empty());

  @override
  Stream<NotificationNavigationState> mapEventToState(NotificationNavigationEvent event) async* {
    if (event is NavigateTo) {
      yield state.update(route: event.route, arguments: event.arguments);
    } else if (event is ResetFromNotification) {
      yield NotificationNavigationState.empty();
    }
  }
}
