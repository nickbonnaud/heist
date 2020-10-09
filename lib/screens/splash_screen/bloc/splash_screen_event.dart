part of 'splash_screen_bloc.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object> get props => [];
}

class MainAnimationCompleted extends SplashScreenEvent {}

class EndAnimationCompleted extends SplashScreenEvent {}

class BootBlocUpdated extends SplashScreenEvent {
  final BootState bootState;

  const BootBlocUpdated({@required this.bootState});

  @override
  List<Object> get props => [bootState];

  @override
  String toString() => 'BootBlocUpdated { bootState: $bootState }';
}

class NextScreenResolved extends SplashScreenEvent {
  final NextScreen nextScreen;

  const NextScreenResolved({@required this.nextScreen});

  @override
  List<Object> get props => [nextScreen];

  @override
  String toString() => 'NextScreenResolved { nextScreen: $nextScreen }';
}
