part of 'setup_tip_card_bloc.dart';

@immutable
class SetupTipCardState extends Equatable {
  final bool isTipRateValid;
  final bool isQuickTipRateValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isTipRateValid && isQuickTipRateValid;

  SetupTipCardState({
    required this.isTipRateValid,
    required this.isQuickTipRateValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory SetupTipCardState.initial() {
    return SetupTipCardState(
      isTipRateValid: true,
      isQuickTipRateValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  SetupTipCardState update({
    bool? isTipRateValid,
    bool? isQuickTipRateValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => SetupTipCardState(
    isTipRateValid: isTipRateValid ?? this.isTipRateValid,
    isQuickTipRateValid: isQuickTipRateValid ?? this.isQuickTipRateValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isTipRateValid, isQuickTipRateValid, isSubmitting, isSuccess, errorMessage];
  
  @override
  String toString() => '''SetupTipCardState {
    isTipRateValid: $isTipRateValid,
    isQuickTipRateValid: $isQuickTipRateValid,
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage
  }''';
}
