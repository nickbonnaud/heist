part of 'profile_setup_screen_bloc.dart';

abstract class ProfileSetupScreenEvent extends Equatable {
  const ProfileSetupScreenEvent();
}

class Init extends ProfileSetupScreenEvent {
  final Customer customer;

  const Init({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() =>  'Init { customer: $customer }';
}

class SectionCompleted extends ProfileSetupScreenEvent {
  final Section section;

  const SectionCompleted({@required this.section});

  @override
  List<Object> get props => [section];

  @override
  String toString() => 'SectionCompleted { section: $section }';
}
