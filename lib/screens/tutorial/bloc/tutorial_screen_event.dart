part of 'tutorial_screen_bloc.dart';

abstract class TutorialScreenEvent extends Equatable {
  const TutorialScreenEvent();

  @override
  List<Object> get props => [];
}

class Next extends TutorialScreenEvent {}

class Previous extends TutorialScreenEvent {}
