part of 'pay_button_bloc.dart';

@immutable
class PayButtonState {
  final bool isEnabled;
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final bool isSubmitFailure;

  final TransactionResource transactionResource;

  PayButtonState({
    @required this.isEnabled,
    @required this.isSubmitting,
    @required this.isSubmitSuccess,
    @required this.isSubmitFailure,
    @required this.transactionResource
  });

  factory PayButtonState.initial({@required TransactionResource transactionResource, @required bool isEnabled}) {
    return PayButtonState(
      isEnabled: isEnabled, 
      isSubmitting: false, 
      isSubmitSuccess: false, 
      isSubmitFailure: false,
      transactionResource: transactionResource
    );
  }

  PayButtonState update({
    bool isEnabled,
    bool isSubmitting,
    bool isSubmitSuccess,
    bool isSubmitFailure,
    TransactionResource transactionResource
  }) {
    return _copyWith(
      isEnabled: isEnabled,
      isSubmitting: isSubmitting,
      isSubmitSuccess: isSubmitSuccess,
      isSubmitFailure: isSubmitFailure,
      transactionResource: transactionResource
    );
  }
  
  PayButtonState _copyWith({
    bool isEnabled,
    bool isSubmitting,
    bool isSubmitSuccess,
    bool isSubmitFailure,
    TransactionResource transactionResource
  }) {
    return PayButtonState(
      isEnabled: isEnabled ?? this.isEnabled,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      isSubmitFailure: isSubmitFailure ?? this.isSubmitFailure,
      transactionResource: transactionResource ?? this.transactionResource
    );
  }

  @override
  String toString() {
    return '''PayButtonState {
      isEnabled: $isEnabled,
      isSubmitting: $isSubmitting,
      isSubmitSuccess: $isSubmitSuccess,
      isSubmitFailure: $isSubmitFailure,
      transactionResource: $transactionResource
    }''';
  }
}
