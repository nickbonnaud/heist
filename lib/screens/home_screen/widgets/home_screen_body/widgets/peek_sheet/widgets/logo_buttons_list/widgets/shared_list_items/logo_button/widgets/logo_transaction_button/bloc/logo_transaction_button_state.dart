part of 'logo_transaction_button_bloc.dart';

@immutable
class LogoTransactionButtonState extends Equatable {
  final bool pressed;

  const LogoTransactionButtonState({required this.pressed});

  factory LogoTransactionButtonState.initial() {
    return const LogoTransactionButtonState(pressed: false);
  }

  LogoTransactionButtonState update({required bool isPressed}) {
    return LogoTransactionButtonState(pressed: isPressed);
  }

  @override
  List<Object> get props => [pressed];
  
  @override
  String toString() => 'LogoTransactionButtonState { pressed: $pressed }';
}
