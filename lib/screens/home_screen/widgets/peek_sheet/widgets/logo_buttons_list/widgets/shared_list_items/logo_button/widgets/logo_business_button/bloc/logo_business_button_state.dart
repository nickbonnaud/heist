part of 'logo_business_button_bloc.dart';

@immutable
class LogoBusinessButtonState extends Equatable {
  final bool pressed;

  LogoBusinessButtonState({required this.pressed});

  factory LogoBusinessButtonState.initial() {
    return LogoBusinessButtonState(pressed: false);
  }

  LogoBusinessButtonState update({required bool isPressed}) {
    return LogoBusinessButtonState(pressed: isPressed);
  }

  @override
  List<Object> get props => [pressed];
  
  @override
  String toString() => 'LogoBusinessButtonState { pressed: $pressed }';
}