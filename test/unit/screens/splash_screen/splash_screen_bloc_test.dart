import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/app/bloc/app_ready_bloc.dart';
import 'package:heist/screens/splash_screen/widgets/bloc/splash_screen_bloc.dart';

class MockAppReadyBloc extends Mock implements AppReadyBloc {}

void main() {
  group("Splash Screen Bloc Tests", () {
    late AppReadyBloc appReadyBloc;
    
    late SplashScreenBloc splashScreenBloc;
    late SplashScreenState _baseState;

    setUp(() {
      appReadyBloc = MockAppReadyBloc();
      whenListen(appReadyBloc, Stream<AppReadyState>.fromIterable([]));

      splashScreenBloc = SplashScreenBloc(appReadyBloc: appReadyBloc);
      _baseState = splashScreenBloc.state;
    });

    tearDown(() {
      splashScreenBloc.close();
    });

    test("Initial state of SplashScreenBloc is SplashScreenState.initial()", () {
      expect(splashScreenBloc.state, SplashScreenState.initial());
    });

    blocTest<SplashScreenBloc, SplashScreenState>(
      "SplashScreenBloc MainAnimationCompleted event yields state: [mainAnimationComplete: true]",
      build: () => splashScreenBloc,
      act: (bloc) => bloc.add(MainAnimationCompleted()),
      expect: () => [_baseState.update(mainAnimationComplete: true)]
    );

    blocTest<SplashScreenBloc, SplashScreenState>(
      "SplashScreenBloc EndAnimationCompleted event yields state: [endAnimationComplete: true]",
      build: () => splashScreenBloc,
      act: (bloc) => bloc.add(EndAnimationCompleted()),
      expect: () => [_baseState.update(endAnimationComplete: true)]
    );

    blocTest<SplashScreenBloc, SplashScreenState>(
      "SplashScreenBloc AppReadyBlocUpdated event yields state: [nextScreen: NextScreen.auth]",
      build: () => splashScreenBloc,
      act: (bloc) => bloc.add(AppReadyBlocUpdated(
        appReadyState: AppReadyState(customerOnboarded: false, permissionChecksComplete: true, permissionsReady: false, authCheckComplete: true, isAuthenticated: false, openTransactionsLoaded: false, nearbyBusinessesLoaded: true, beaconsLoaded: true)
      )),
      expect: () => [_baseState.update(nextScreen: NextScreen.auth)]
    );

    blocTest<SplashScreenBloc, SplashScreenState>(
      "SplashScreenBloc AppReadyBlocUpdated event && !permissionsReady yields state: [nextScreen: NextScreen.onboard]",
      build: () => splashScreenBloc,
      act: (bloc) => bloc.add(AppReadyBlocUpdated(
        appReadyState: AppReadyState(customerOnboarded: false, permissionChecksComplete: true, permissionsReady: false, authCheckComplete: true, isAuthenticated: true, openTransactionsLoaded: false, nearbyBusinessesLoaded: true, beaconsLoaded: true)
      )),
      expect: () => [_baseState.update(nextScreen: NextScreen.onboard)]
    );
    
    blocTest<SplashScreenBloc, SplashScreenState>(
      "SplashScreenBloc AppReadyBlocUpdated event yields state: [nextScreen: NextScreen.main]",
      build: () => splashScreenBloc,
      act: (bloc) => bloc.add(AppReadyBlocUpdated(
        appReadyState: AppReadyState(customerOnboarded: true, permissionChecksComplete: true, permissionsReady: true, authCheckComplete: true, isAuthenticated: true, openTransactionsLoaded: true, nearbyBusinessesLoaded: true, beaconsLoaded: true)
      )),
      expect: () => [_baseState.update(nextScreen: NextScreen.main)]
    );

    blocTest<SplashScreenBloc, SplashScreenState>(
      "SplashScreenBloc appReadyBloc.stream triggers AppReadyBlocUpdated",
      build: () {
        whenListen(appReadyBloc, Stream<AppReadyState>.fromIterable([AppReadyState(customerOnboarded: false, permissionChecksComplete: false, permissionsReady: false, authCheckComplete: true, isAuthenticated: false, openTransactionsLoaded: false, nearbyBusinessesLoaded: false, beaconsLoaded: false)]));
        return SplashScreenBloc(appReadyBloc: appReadyBloc);
      },
      expect: () => [_baseState.update(nextScreen: NextScreen.auth)]
    );
  });
}