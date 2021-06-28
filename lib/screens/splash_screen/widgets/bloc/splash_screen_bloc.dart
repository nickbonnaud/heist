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
        
        _appReadyBlocSubscription = appReadyBloc.stream.listen((AppReadyState state) {
          add(AppReadyBlocUpdated(appReadyState: state));
        });
      }

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    if (event is MainAnimationCompleted) {
      yield state.update(mainAnimationComplete: true);
    } else if (event is EndAnimationCompleted) {
      yield state.update(endAnimationComplete: true);
    } else if (event is AppReadyBlocUpdated) {
      yield* _mapBootBlocUpdatedToState(appReadyState: event.appReadyState);
    }
  }

  @override
  Future<void> close() {
    _appReadyBlocSubscription.cancel();
    return super.close();
  }

  Stream<SplashScreenState> _mapBootBlocUpdatedToState({required AppReadyState appReadyState}) async* {
    if (state.nextScreen == null) {
      if (appReadyState.authCheckComplete) {
        if (!appReadyState.isAuthenticated) {
          yield state.update(nextScreen: NextScreen.auth);
          return;
        }

        if (appReadyState.permissionChecksComplete && !appReadyState.permissionsReady) {
          yield state.update(nextScreen: NextScreen.onboard);
          return;
        }

        if (!appReadyState.customerOnboarded) {
          yield state.update(nextScreen: NextScreen.onboard);
          return;
        }

        if (appReadyState.isDataLoaded) {
          yield state.update(nextScreen: NextScreen.main);
          return;
        }
      }
    }
  }
}
