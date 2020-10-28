part of 'message_input_bloc.dart';

@immutable
class MessageInputState {
  final bool isInputValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  MessageInputState({
    @required this.isInputValid,
    @required this.isSubmitting,
    @required this.isFailure,
    @required this.isSuccess
  });

  factory MessageInputState.initial() {
    return MessageInputState(
      isInputValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  MessageInputState update({
    bool isInputValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess
  }) {
    return _copyWith(
      isInputValid: isInputValid,
      isSubmitting: isSubmitting,
      isFailure: isFailure,
      isSuccess: isSuccess
    );
  }
  
  MessageInputState _copyWith({
    bool isInputValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess
  }) {
    return MessageInputState(
      isInputValid: isInputValid ?? this.isInputValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }

  @override
  String toString() => 'MessageInputState { isInputValid: $isInputValid, isSubmitting: $isSubmitting, isFailure: $isFailure, isSuccess: $isSuccess }';
}
