part of 'transaction_business_picker_bloc.dart';

@immutable
class TransactionBusinessPickerState extends Equatable {
  final List<Business> availableBusinesses;

  const TransactionBusinessPickerState({required this.availableBusinesses});

  factory TransactionBusinessPickerState.initial() {
    return TransactionBusinessPickerState(availableBusinesses: []);
  }

  TransactionBusinessPickerState update({List<Business>? availableBusinesses}) {
    return TransactionBusinessPickerState(availableBusinesses: availableBusinesses ?? this.availableBusinesses);
  }
  
  @override
  List<Object> get props => [availableBusinesses];
  
  @override
  String toString() => 'TransactionBusinessPickerState { availableBusinesses: $availableBusinesses }';
}

