part of 'logo_business_button_bloc.dart';

abstract class LogoBusinessButtonEvent extends Equatable {
  const LogoBusinessButtonEvent();

  @override
  List<Object> get props => [];
}

class TogglePressed extends  LogoBusinessButtonEvent {}
