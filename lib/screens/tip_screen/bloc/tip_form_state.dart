part of 'tip_form_bloc.dart';

@immutable
class TipFormState extends Equatable {
  final bool isTipRateValid;
  final bool isQuickTipRateValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  bool get isFormValid => isTipRateValid && isQuickTipRateValid;

  TipFormState({
    required this.isTipRateValid,
    required this.isQuickTipRateValid,
    required this.isSubmitting,
    required this.isFailure,
    required this.isSuccess
  });

  factory TipFormState.initial() {
    return TipFormState(
      isTipRateValid: true,
      isQuickTipRateValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  TipFormState update({
    bool? isTipRateValid,
    bool? isQuickTipRateValid,
    bool? isSubmitting,
    bool? isFailure,
    bool? isSuccess
  }) => TipFormState(
    isTipRateValid: isTipRateValid ?? this.isTipRateValid,
    isQuickTipRateValid: isQuickTipRateValid ?? this.isQuickTipRateValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isFailure: isFailure ?? this.isFailure,
    isSuccess: isSuccess ?? this.isSuccess
  );

  @override
  List<Object> get props => [isTipRateValid, isQuickTipRateValid, isSubmitting, isFailure, isSuccess];

  @override
  String toString() => 'TipFormState { isTipRateValid: $isTipRateValid, isQuickTipRateValid: $isQuickTipRateValid, isSubmitting: $isSubmitting, isFailure: $isFailure, isSuccess: $isSuccess }';
}
