part of 'delete_ticket_button_bloc.dart';

@immutable
class DeleteTicketButtonState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  DeleteTicketButtonState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory DeleteTicketButtonState.initial() {
    return DeleteTicketButtonState(
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  DeleteTicketButtonState update({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => DeleteTicketButtonState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [isSubmitting, isSuccess, errorMessage];
  
  @override
  String toString() => 'DeleteTicketButtonState { isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
