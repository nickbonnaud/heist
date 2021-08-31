import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';

class TransactionPickerArgs extends Equatable {
  final Business business;
  final bool fromSettings;

  const TransactionPickerArgs({required this.business, required this.fromSettings});

  @override
  List<Object> get props => [business, fromSettings];

  @override
  String toString() => 'TransactionPickerArgs { business: $business, fromSettings: $fromSettings }';
}