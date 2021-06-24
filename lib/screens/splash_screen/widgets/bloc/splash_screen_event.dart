part of 'splash_screen_bloc.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object> get props => [];
}

class MainAnimationCompleted extends SplashScreenEvent {}

class EndAnimationCompleted extends SplashScreenEvent {}

class AppReadyBlocUpdated extends SplashScreenEvent {
  final AppReadyState appReadyState;

  const AppReadyBlocUpdated({required this.appReadyState});

  @override
  List<Object> get props => [appReadyState];

  @override
  String toString() => 'AppReadyBlocUpdated { appReadyState: $appReadyState }';
}
