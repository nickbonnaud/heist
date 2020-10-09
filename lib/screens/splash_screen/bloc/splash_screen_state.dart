part of 'splash_screen_bloc.dart';

@immutable
class SplashScreenState {
  final bool mainAnimationComplete;
  final bool endAnimationComplete;
  final NextScreen nextScreen;


  SplashScreenState({
    @required this.mainAnimationComplete,
    @required this.endAnimationComplete,
    @required this.nextScreen

  });

  factory SplashScreenState.initial() {
    return SplashScreenState(
      mainAnimationComplete: false,
      endAnimationComplete: false,
      nextScreen: null

    );
  }

  SplashScreenState update({
    bool mainAnimationComplete,
    bool endAnimationComplete,
    NextScreen nextScreen

  }) {
    return _copyWith(
      mainAnimationComplete: mainAnimationComplete,
      endAnimationComplete: endAnimationComplete,
      nextScreen: nextScreen

    );
  }
  
  SplashScreenState _copyWith({
    bool mainAnimationComplete,
    bool endAnimationComplete,
    NextScreen nextScreen

  }) {
    return SplashScreenState(
      mainAnimationComplete: mainAnimationComplete ?? this.mainAnimationComplete,
      endAnimationComplete: endAnimationComplete ?? this.endAnimationComplete,
      nextScreen: nextScreen ?? this.nextScreen
    );
  }

  @override
  String toString() => 'SplashScreenState { mainAnimationComplete: $mainAnimationComplete, endAnimationComplete: $endAnimationComplete, nextScreen: $nextScreen }';
}

