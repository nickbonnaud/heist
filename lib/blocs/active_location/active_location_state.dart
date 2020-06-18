part of 'active_location_bloc.dart';

abstract class ActiveLocationState extends Equatable {
  const ActiveLocationState();

  @override
  List<Object> get props => [];

  List<ActiveLocation> get locations => [];
}

class NoActiveLocations extends ActiveLocationState {
  final bool addActiveLocationFail;
  final bool removeActiveLocationFail;

  NoActiveLocations({this.addActiveLocationFail = false, this.removeActiveLocationFail = false});

  NoActiveLocations update({bool addActiveLocationFail, bool removeActiveLocationFail}) {
    return _copyWith(
      addActiveLocationFail: addActiveLocationFail,
      removeActiveLocationFail: removeActiveLocationFail
    );
  }
  
  NoActiveLocations _copyWith({bool addActiveLocationFail, bool removeActiveLocationFail}) {
    return NoActiveLocations(
      addActiveLocationFail: addActiveLocationFail ?? this.addActiveLocationFail,
      removeActiveLocationFail: removeActiveLocationFail ?? this.removeActiveLocationFail
    );
  }

  @override
  List<Object> get props => [addActiveLocationFail, removeActiveLocationFail];

  @override
  String toString() => 'NoActiveLocations { addActiveLocationFail: $addActiveLocationFail, removeActiveLocationFail: $removeActiveLocationFail }';
}

class CurrentActiveLocations extends ActiveLocationState {
  final List<ActiveLocation> activeLocations;
  final bool addActiveLocationFail;
  final bool removeActiveLocationFail;

  CurrentActiveLocations({@required this.activeLocations, this.addActiveLocationFail = false, this.removeActiveLocationFail = false});

  CurrentActiveLocations update({List<ActiveLocation> activeLocations, bool addActiveLocationFail, bool removeActiveLocationFail}) {
    return _copyWith(
      activeLocations: activeLocations,
      addActiveLocationFail: addActiveLocationFail,
      removeActiveLocationFail: removeActiveLocationFail
    );
  }
  
  CurrentActiveLocations _copyWith({List<ActiveLocation> activeLocations, bool addActiveLocationFail, bool removeActiveLocationFail}) {
    return CurrentActiveLocations(
      activeLocations: activeLocations ?? this.activeLocations,
      addActiveLocationFail: addActiveLocationFail ?? this.addActiveLocationFail,
      removeActiveLocationFail: removeActiveLocationFail ?? this.removeActiveLocationFail
    );
  }

  @override
  List<ActiveLocation> get locations => activeLocations;
  
  @override
  List<Object> get props => [activeLocations, addActiveLocationFail, removeActiveLocationFail];

  @override
  String toString() => 'CurrentActiveLocations { activeLocations: $activeLocations, addActiveLocationFail: $addActiveLocationFail, removeActiveLocationFail: $removeActiveLocationFail }';
}
