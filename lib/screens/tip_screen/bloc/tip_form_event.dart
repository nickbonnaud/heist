part of 'tip_form_bloc.dart';

abstract class TipFormEvent extends Equatable {
  const TipFormEvent();

  @override
  List<Object?> get props => [];
}

class TipRateChanged extends TipFormEvent {
  final String tipRate;
  
  const TipRateChanged({required this.tipRate});

  @override
  List<Object> get props => [tipRate];

  @override
  String toString() => 'TipRateChanged { tipRate: $tipRate }';
}

class QuickTipRateChanged extends TipFormEvent {
  final String quickTipRate;
  
  const QuickTipRateChanged({required this.quickTipRate});

  @override
  List<Object> get props => [quickTipRate];

  @override
  String toString() => 'QuickTipRateChanged { quickTipRate: $quickTipRate }';
}

class Submitted extends TipFormEvent {}

class Reset extends TipFormEvent {}


