import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'notification_navigation_event.dart';
part 'notification_navigation_state.dart';

class NotificationNavigationBloc extends Bloc<NotificationNavigationEvent, NotificationNavigationState> {
  NotificationNavigationBloc()
    : super(NotificationNavigationState.empty()) { _eventHandler(); }

  void _eventHandler() {
    on<NavigateTo>((event, emit) => _mapNavigateToToState(event: event, emit: emit));
    on<ResetFromNotification>((event, emit) => _mapResetFromNotificationToState(emit: emit));
  }

  void _mapNavigateToToState({required NavigateTo event, required Emitter<NotificationNavigationState> emit}) async {
    emit(state.update(route: event.route, arguments: event.arguments));
  }

  void _mapResetFromNotificationToState({required Emitter<NotificationNavigationState> emit}) async {
    emit(NotificationNavigationState.empty());
  }
}
