part of 'active_location_bloc.dart';

abstract class ActiveLocationEvent extends Equatable {
  const ActiveLocationEvent();

  @override
  List<Object> get props => [];
}

class NewActiveLocation extends ActiveLocationEvent {
  final Beacon beacon;

   const NewActiveLocation({required this.beacon});

  @override
  List<Object> get props => [beacon];

  @override
  String toString() => 'NewActiveLocation { beacon: $beacon }';
}

class RemoveActiveLocation extends ActiveLocationEvent {
  final Beacon beacon;

  const RemoveActiveLocation({required this.beacon});

  @override
  List<Object> get props => [beacon];

  @override
  String toString() => 'RemoveActiveLocation { beacon: $beacon }';
}

class TransactionAdded extends ActiveLocationEvent {
  final Business business;
  final String transactionIdentifier;

  const TransactionAdded({required this.business, required this.transactionIdentifier});

  @override
  List<Object> get props => [business, transactionIdentifier];

  @override
  String toString() => 'TransactionAdded { business: $business, transactionIdentifier: $transactionIdentifier }';
}

class ResetActiveLocations extends ActiveLocationEvent {}
