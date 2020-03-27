part of 'active_location_bloc.dart';

abstract class ActiveLocationState extends Equatable {
  const ActiveLocationState();

  @override
  List<Object> get props => [];
}

class NoActiveLocations extends ActiveLocationState {}

class CurrentActiveLocations extends ActiveLocationState {
  final List<ActiveLocation> activeLocations;

  CurrentActiveLocations({@required this.activeLocations});

  @override
  List<Object> get props => [activeLocations];

  @override
  String toString() => 'CurrentActiveLocations { activeLocations: $activeLocations }';
}

class SendActiveLocationFail extends ActiveLocationState {
  final List<ActiveLocation> activeLocations;

  SendActiveLocationFail({@required this.activeLocations});

  @override
  List<Object> get props => [activeLocations];

  @override
  String toString() => 'SendActiveLocationFail { activeLocations: $activeLocations }';
}

class DeleteActiveLocationFail extends ActiveLocationState {
  final List<ActiveLocation> activeLocations;

  DeleteActiveLocationFail({@required this.activeLocations});

  @override
  List<Object> get props => [activeLocations];

  @override
  String toString() => 'DeleteActiveLocationFail { activeLocations: $activeLocations }';
}
