part of 'pay_button_bloc.dart';

@immutable
class PayButtonState extends Equatable {
  final bool isEnabled;
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final String errorMessage;

  const PayButtonState({
    required this.isEnabled,
    required this.isSubmitting,
    required this.isSubmitSuccess,
    required this.errorMessage,
  });

  factory PayButtonState.initial({required bool isEnabled}) {
    return PayButtonState(
      isEnabled: isEnabled, 
      isSubmitting: false, 
      isSubmitSuccess: false, 
      errorMessage: "",
    );
  }

  PayButtonState update({
    bool? isEnabled,
    bool? isSubmitting,
    bool? isSubmitSuccess,
    String? errorMessage,
  }) => PayButtonState(
    isEnabled: isEnabled ?? this.isEnabled,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object> get props => [isEnabled, isSubmitting, isSubmitSuccess, errorMessage];
  
  @override
  String toString() {
    return '''PayButtonState {
      isEnabled: $isEnabled,
      isSubmitting: $isSubmitting,
      isSubmitSuccess: $isSubmitSuccess,
      errorMessage: $errorMessage,
    }''';
  }
}
