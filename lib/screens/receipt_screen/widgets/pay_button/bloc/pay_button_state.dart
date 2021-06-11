part of 'pay_button_bloc.dart';

@immutable
class PayButtonState extends Equatable {
  final bool isEnabled;
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final bool isSubmitFailure;

  PayButtonState({
    required this.isEnabled,
    required this.isSubmitting,
    required this.isSubmitSuccess,
    required this.isSubmitFailure,
  });

  factory PayButtonState.initial({required bool isEnabled}) {
    return PayButtonState(
      isEnabled: isEnabled, 
      isSubmitting: false, 
      isSubmitSuccess: false, 
      isSubmitFailure: false,
    );
  }

  PayButtonState update({
    bool? isEnabled,
    bool? isSubmitting,
    bool? isSubmitSuccess,
    bool? isSubmitFailure,
  }) => PayButtonState(
    isEnabled: isEnabled ?? this.isEnabled,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
    isSubmitFailure: isSubmitFailure ?? this.isSubmitFailure,
  );

  @override
  List<Object> get props => [isEnabled, isSubmitting, isSubmitSuccess, isSubmitFailure];
  
  @override
  String toString() {
    return '''PayButtonState {
      isEnabled: $isEnabled,
      isSubmitting: $isSubmitting,
      isSubmitSuccess: $isSubmitSuccess,
      isSubmitFailure: $isSubmitFailure,
    }''';
  }
}
