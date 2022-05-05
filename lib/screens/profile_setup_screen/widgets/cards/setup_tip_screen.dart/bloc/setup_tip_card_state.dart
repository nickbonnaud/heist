part of 'setup_tip_card_bloc.dart';

@immutable
class SetupTipCardState extends Equatable {
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

  const SetupTipCardState({
    required this.tipRate,
    required this.quickTipRate,

    required this.isTipRateValid,
    required this.isQuickTipRateValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory SetupTipCardState.initial() {
    return const SetupTipCardState(
      tipRate: '15',
      quickTipRate: '5',

      isTipRateValid: true,
      isQuickTipRateValid: true,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  SetupTipCardState update({
    String? tipRate,
    String? quickTipRate,

    bool? isTipRateValid,
    bool? isQuickTipRateValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => SetupTipCardState(
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
  String toString() => '''SetupTipCardState {
    tipRate: $tipRate,
    quickTipRate: $quickTipRate,

    isTipRateValid: $isTipRateValid,
    isQuickTipRateValid: $isQuickTipRateValid,
    
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage
  }''';
}
