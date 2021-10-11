import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/app/bloc/app_ready_bloc.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

enum NextScreen {
  auth,
  onboard,
  main
}

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  late StreamSubscription _appReadyBlocSubscription;

  SplashScreenBloc({required AppReadyBloc appReadyBloc}) 
    : super(SplashScreenState.initial()) {
        
      _eventHandler();
      
      _appReadyBlocSubscription = appReadyBloc.stream.listen((AppReadyState state) {
        add(AppReadyBlocUpdated(appReadyState: state));
      });
  }

  void _eventHandler() {
    on<MainAnimationCompleted>((event, emit) => _mapMainAnimationCompletedToState(emit: emit));
    on<EndAnimationCompleted>((event, emit) => _mapEndAnimationCompletedToState(emit: emit));
    on<AppReadyBlocUpdated>((event, emit) => _mapBootBlocUpdatedToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _appReadyBlocSubscription.cancel();
    return super.close();
  }

  void _mapMainAnimationCompletedToState({required Emitter<SplashScreenState> emit}) {
    emit(state.update(mainAnimationComplete: true));
  }

  void _mapEndAnimationCompletedToState({required Emitter<SplashScreenState> emit}) {
    emit(state.update(endAnimationComplete: true));
  }
  
  void _mapBootBlocUpdatedToState({required AppReadyBlocUpdated event, required Emitter<SplashScreenState> emit}) {
    if (state.nextScreen == null) {
      if (event.appReadyState.authCheckComplete) {
        if (!event.appReadyState.isAuthenticated) {
          emit(state.update(nextScreen: NextScreen.auth));
          return;
        }

        if (event.appReadyState.permissionChecksComplete && !event.appReadyState.permissionsReady) {
          emit(state.update(nextScreen: NextScreen.onboard));
          return;
        }

        if (!event.appReadyState.customerOnboarded) {
          emit(state.update(nextScreen: NextScreen.onboard));
          return;
        }

        if (event.appReadyState.isDataLoaded) {
          emit(state.update(nextScreen: NextScreen.main));
          return;
        }
      }
    }
  }
}
