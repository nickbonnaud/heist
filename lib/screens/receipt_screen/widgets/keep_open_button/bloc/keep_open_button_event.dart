part of 'keep_open_button_bloc.dart';

abstract class KeepOpenButtonEvent extends Equatable {
  const KeepOpenButtonEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends KeepOpenButtonEvent {
  final String transactionId;

  const Submitted({@required this.transactionId});

  @override
  List<Object> get props => [transactionId];

  @override
  String toString() => 'Submitted { transactionId: $transactionId }';
}

class Reset extends KeepOpenButtonEvent {}
