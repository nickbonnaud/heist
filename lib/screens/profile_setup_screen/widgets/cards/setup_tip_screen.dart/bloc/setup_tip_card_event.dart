part of 'setup_tip_card_bloc.dart';

abstract class SetupTipCardEvent extends Equatable {
  const SetupTipCardEvent();

  @override
  List<Object> get props => [];
}

class TipRateChanged extends SetupTipCardEvent {
  final int tipRate;
  
  const TipRateChanged({required this.tipRate});

  @override
  List<Object> get props => [tipRate];

  @override
  String toString() => 'TipRateChanged { tipRate: $tipRate }';
}

class QuickTipRateChanged extends SetupTipCardEvent {
  final int quickTipRate;
  
  const QuickTipRateChanged({required this.quickTipRate});

  @override
  List<Object> get props => [quickTipRate];

  @override
  String toString() => 'QuickTipRateChanged { quickTipRate: $quickTipRate }';
}

class Submitted extends SetupTipCardEvent {
  final int tipRate;
  final int quickTipRate;
  final String accountIdentifier;

  Submitted({required this.tipRate, required this.quickTipRate, required this.accountIdentifier});

  @override
  List<Object> get props => [tipRate, quickTipRate, accountIdentifier];

  @override
  String toString() => 'Submitted { tipRate: $tipRate, quickTipRate: $quickTipRate, accountIdentifier, $accountIdentifier }';
}

class Reset extends SetupTipCardEvent {}