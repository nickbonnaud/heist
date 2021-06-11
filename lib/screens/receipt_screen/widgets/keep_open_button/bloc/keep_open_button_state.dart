part of 'keep_open_button_bloc.dart';

@immutable
class KeepOpenButtonState extends Equatable {
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final bool isSubmitFailure;

  KeepOpenButtonState({
    required this.isSubmitting,
    required this.isSubmitSuccess,
    required this.isSubmitFailure,
  });

  factory KeepOpenButtonState.initial() {
    return KeepOpenButtonState(
      isSubmitting: false,
      isSubmitSuccess: false,
      isSubmitFailure: false
    );
  }

  KeepOpenButtonState update({
    bool? isSubmitting,
    bool? isSubmitSuccess,
    bool? isSubmitFailure,
  }) => KeepOpenButtonState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
    isSubmitFailure: isSubmitFailure ?? this.isSubmitFailure,
  );

  @override
  List<Object?> get props => [isSubmitting, isSubmitSuccess, isSubmitFailure];

  @override
  String toString() => 'KeepOpenButtonState { isSubmitting: $isSubmitting, isSubmitSuccess: $isSubmitSuccess, isSubmitFailure: $isSubmitFailure }';
}
