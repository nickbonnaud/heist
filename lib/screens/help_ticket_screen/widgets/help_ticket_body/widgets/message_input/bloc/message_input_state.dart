part of 'message_input_bloc.dart';

@immutable
class MessageInputState extends Equatable {
  final bool isInputValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  MessageInputState({
    required this.isInputValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory MessageInputState.initial() {
    return MessageInputState(
      isInputValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  MessageInputState update({
    bool? isInputValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => MessageInputState(
    isInputValid: isInputValid ?? this.isInputValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );
  
  @override
  List<Object?> get props => [isInputValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'MessageInputState { isInputValid: $isInputValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
