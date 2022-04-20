part of 'customer_bloc.dart';

@immutable
class CustomerState extends Equatable {
  final Customer? customer;
  final bool loading;
  final String errorMessage;

  bool get onboarded => customer!.status.code > 103;

  const CustomerState({
    this.customer,
    required this.loading,
    required this.errorMessage
  });

  factory CustomerState.initial() {
    return const CustomerState(
      customer: null,
      loading: true,
      errorMessage: ""
    );
  }

  CustomerState update({
    Customer? customer,
    bool? loading,
    String? errorMessage
  }) => CustomerState(
    customer: customer ?? this.customer,
    loading: loading ?? this.loading,
    errorMessage: errorMessage ?? this.errorMessage
  );
  
  @override
  List<Object?> get props => [customer, loading, errorMessage];

  @override
  String toString() => 'CustomerState { customer: $customer, loading: $loading, errorMessage: $errorMessage }';
}
