part of 'setup_tip_screen_bloc.dart';

abstract class SetupTipScreenEvent extends Equatable {
  const SetupTipScreenEvent();

  @override
  List<Object> get props => [];
}

class TipRateChanged extends SetupTipScreenEvent {
  final int tipRate;
  
  const TipRateChanged({@required this.tipRate});

  @override
  List<Object> get props => [tipRate];

  @override
  String toString() => 'TipRateChanged { tipRate: $tipRate }';
}

class QuickTipRateChanged extends SetupTipScreenEvent {
  final int quickTipRate;
  
  const QuickTipRateChanged({@required this.quickTipRate});

  @override
  List<Object> get props => [quickTipRate];

  @override
  String toString() => 'QuickTipRateChanged { quickTipRate: $quickTipRate }';
}

class Submitted extends SetupTipScreenEvent {
  final Customer customer;
  final int tipRate;
  final int quickTipRate;

  Submitted({@required this.customer, @required this.tipRate, @required this.quickTipRate});

  @override
  List<Object> get props => [customer, tipRate, quickTipRate];

  @override
  String toString() => 'Submitted { customer: $customer, tipRate: $tipRate, quickTipRate: $quickTipRate }';
}

class Reset extends SetupTipScreenEvent {}