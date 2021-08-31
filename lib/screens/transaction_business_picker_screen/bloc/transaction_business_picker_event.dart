part of 'transaction_business_picker_bloc.dart';

abstract class TransactionBusinessPickerEvent extends Equatable {
  const TransactionBusinessPickerEvent();

  @override
  List<Object> get props => [];
}

class Init extends TransactionBusinessPickerEvent {
  final List<ActiveLocation> activeLocations;

  const Init({required this.activeLocations});

  @override
  List<Object> get props => [activeLocations];

  @override
  String toString() => 'Init { activeLocations: $activeLocations }'; 
}

class ActiveLocationsChanged extends TransactionBusinessPickerEvent {
  final List<ActiveLocation> activeLocations;

  const ActiveLocationsChanged({required this.activeLocations});

  @override
  List<Object> get props => [activeLocations];

  @override
  String toString() => 'ActiveLocationsChanged { activeLocations: $activeLocations }'; 
}