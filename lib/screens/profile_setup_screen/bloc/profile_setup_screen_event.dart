part of 'profile_setup_screen_bloc.dart';

abstract class ProfileSetupScreenEvent extends Equatable {
  const ProfileSetupScreenEvent();
}

class Init extends ProfileSetupScreenEvent {
  final Status status;

  const Init({required this.status});

  @override
  List<Object> get props => [status];

  @override
  String toString() =>  'Init { status: $status }';
}

class SectionCompleted extends ProfileSetupScreenEvent {
  final Section section;

  const SectionCompleted({required this.section});

  @override
  List<Object> get props => [section];

  @override
  String toString() => 'SectionCompleted { section: $section }';
}
