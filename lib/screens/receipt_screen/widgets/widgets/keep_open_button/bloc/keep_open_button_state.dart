part of 'keep_open_button_bloc.dart';

@immutable
class KeepOpenButtonState extends Equatable {
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final String errorMessage;

  KeepOpenButtonState({
    required this.isSubmitting,
    required this.isSubmitSuccess,
    required this.errorMessage,
  });

  factory KeepOpenButtonState.initial() {
    return KeepOpenButtonState(
      isSubmitting: false,
      isSubmitSuccess: false,
      errorMessage: ""
    );
  }

  KeepOpenButtonState update({
    bool? isSubmitting,
    bool? isSubmitSuccess,
    String? errorMessage,
  }) => KeepOpenButtonState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [isSubmitting, isSubmitSuccess, errorMessage];

  @override
  String toString() => 'KeepOpenButtonState { isSubmitting: $isSubmitting, isSubmitSuccess: $isSubmitSuccess, errorMessage: $errorMessage }';
}
