part of 'delete_ticket_button_bloc.dart';

@immutable
class DeleteTicketButtonState {
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  DeleteTicketButtonState({
    @required this.isSubmitting,
    @required this.isFailure,
    @required this.isSuccess
  });

  factory DeleteTicketButtonState.initial() {
    return DeleteTicketButtonState(
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  DeleteTicketButtonState update({
    bool isSubmitting,
    bool isFailure,
    bool isSuccess
  }) {
    return _copyWith(
      isSubmitting: isSubmitting,
      isFailure: isFailure,
      isSuccess: isSuccess
    );
  }
  
  DeleteTicketButtonState _copyWith({
    bool isSubmitting,
    bool isFailure,
    bool isSuccess
  }) {
    return DeleteTicketButtonState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }

  @override
  String toString() => 'DeleteTicketButtonState { isSubmitting: $isSubmitting, isFailure: $isFailure, isSuccess: $isSuccess }';
}
