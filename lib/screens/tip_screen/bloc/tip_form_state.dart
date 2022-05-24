part of 'tip_form_bloc.dart';

@immutable
class TipFormState extends Equatable {
  final String tipRate;
  final String quickTipRate;
  
  final bool isTipRateValid;
  final bool isQuickTipRateValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => 
    isTipRateValid && tipRate.isNotEmpty &&
    isQuickTipRateValid && quickTipRate.isNotEmpty;

  const TipFormState({
    required this.tipRate,
    required this.quickTipRate,

    required this.isTipRateValid,
    required this.isQuickTipRateValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory TipFormState.initial({required Account account}) {
    return TipFormState(
      tipRate: account.tipRate.toString(),
      quickTipRate: account.quickTipRate.toString(),
      
      isTipRateValid: true,
      isQuickTipRateValid: true,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  TipFormState update({
    String? tipRate,
    String? quickTipRate,

    bool? isTipRateValid,
    bool? isQuickTipRateValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => TipFormState(
    tipRate: tipRate ?? this.tipRate,
    quickTipRate: quickTipRate ?? this.quickTipRate,

    isTipRateValid: isTipRateValid ?? this.isTipRateValid,
    isQuickTipRateValid: isQuickTipRateValid ?? this.isQuickTipRateValid,

    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [tipRate, quickTipRate, isTipRateValid, isQuickTipRateValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'TipFormState { tipRate: $tipRate, quickTipRate: $quickTipRate, isTipRateValid: $isTipRateValid, isQuickTipRateValid: $isQuickTipRateValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
