part of 'logo_transaction_button_bloc.dart';

abstract class LogoTransactionButtonEvent extends Equatable {
  const LogoTransactionButtonEvent();

  @override
  List<Object> get props => [];
}

class TogglePressed extends LogoTransactionButtonEvent {}
