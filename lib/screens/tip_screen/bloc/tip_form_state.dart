part of 'tip_form_bloc.dart';

@immutable
class TipFormState extends Equatable {
  final bool isTipRateValid;
  final bool isQuickTipRateValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isTipRateValid && isQuickTipRateValid;

  TipFormState({
    required this.isTipRateValid,
    required this.isQuickTipRateValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory TipFormState.initial() {
    return TipFormState(
      isTipRateValid: true,
      isQuickTipRateValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  TipFormState update({
    bool? isTipRateValid,
    bool? isQuickTipRateValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => TipFormState(
    isTipRateValid: isTipRateValid ?? this.isTipRateValid,
    isQuickTipRateValid: isQuickTipRateValid ?? this.isQuickTipRateValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isTipRateValid, isQuickTipRateValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'TipFormState { isTipRateValid: $isTipRateValid, isQuickTipRateValid: $isQuickTipRateValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
