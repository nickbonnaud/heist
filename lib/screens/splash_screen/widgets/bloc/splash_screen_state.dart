part of 'splash_screen_bloc.dart';

@immutable
class SplashScreenState extends Equatable {
  final bool mainAnimationComplete;
  final bool endAnimationComplete;
  final NextScreen? nextScreen;


  SplashScreenState({
    required this.mainAnimationComplete,
    required this.endAnimationComplete,
    required this.nextScreen
  });

  factory SplashScreenState.initial() {
    return SplashScreenState(
      mainAnimationComplete: false,
      endAnimationComplete: false,
      nextScreen: null

    );
  }

  SplashScreenState update({
    bool? mainAnimationComplete,
    bool? endAnimationComplete,
    NextScreen? nextScreen

  }) => SplashScreenState(
    mainAnimationComplete: mainAnimationComplete ?? this.mainAnimationComplete,
    endAnimationComplete: endAnimationComplete ?? this.endAnimationComplete,
    nextScreen: nextScreen ?? this.nextScreen
  );

  @override
  List<Object?> get props => [mainAnimationComplete, endAnimationComplete, nextScreen];
  
  @override
  String toString() => 'SplashScreenState { mainAnimationComplete: $mainAnimationComplete, endAnimationComplete: $endAnimationComplete, nextScreen: $nextScreen }';
}

