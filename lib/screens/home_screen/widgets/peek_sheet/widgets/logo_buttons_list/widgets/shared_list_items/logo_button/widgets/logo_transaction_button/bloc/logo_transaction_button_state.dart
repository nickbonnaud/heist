part of 'logo_transaction_button_bloc.dart';

@immutable
class LogoTransactionButtonState {
  final bool pressed;

  LogoTransactionButtonState({required this.pressed});

  factory LogoTransactionButtonState.initial() {
    return LogoTransactionButtonState(pressed: false);
  }

  LogoTransactionButtonState update({required bool isPressed}) {
    return LogoTransactionButtonState(pressed: isPressed);
  }

  @override
  String toString() => 'LogoTransactionButtonState { pressed: $pressed }';
}
