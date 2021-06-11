part of 'faq_body_bloc.dart';

abstract class FaqBodyEvent extends Equatable {
  const FaqBodyEvent();

  @override
  List<Object> get props => [];
}

class ToggleAnswerVisibility extends FaqBodyEvent {
  final Faq faq;

  const ToggleAnswerVisibility({required this.faq});

  @override
  List<Object> get props => [faq];

  @override
  String toString() => 'ToggleAnswerVisibility { faq: $faq }';
}
