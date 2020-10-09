import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

enum NextScreen {
  auth,
  onboard,
  main
}

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  StreamSubscription _bootBlocSubscription;

  SplashScreenBloc({@required BootBloc bootBloc}) 
    : assert(bootBloc != null),
      super(SplashScreenState.initial()) {
        
        _bootBlocSubscription = bootBloc.listen((BootState state) {
          add(BootBlocUpdated(bootState: state));
        });
      }

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    if (event is MainAnimationCompleted) {
      yield state.update(mainAnimationComplete: true);
    } else if (event is EndAnimationCompleted) {
      yield state.update(endAnimationComplete: true);
    } else if (event is BootBlocUpdated) {
      yield* _mapBootBlocUpdatedToState(event.bootState);
    } else if (event is NextScreenResolved) {
      yield state.update(nextScreen: event.nextScreen);
    }
  }

  @override
  Future<void> close() {
    _bootBlocSubscription.cancel();
    return super.close();
  }

  Stream<SplashScreenState> _mapBootBlocUpdatedToState(BootState bootState) async* {
    if (state.nextScreen == null) {
      if (bootState.authCheckComplete) {
        if (!bootState.isAuthenticated) {
          yield state.update(nextScreen: NextScreen.auth);
          return;
        }

        if (bootState.permissionChecksComplete && !bootState.permissionsReady) {
          yield state.update(nextScreen: NextScreen.onboard);
          return;
        }

        if (!bootState.customerOnboarded) {
          yield state.update(nextScreen: NextScreen.onboard);
          return;
        }

        if (bootState.isDataLoaded) {
          yield state.update(nextScreen: NextScreen.main);
          return;
        }
      }
    }
  }
}
