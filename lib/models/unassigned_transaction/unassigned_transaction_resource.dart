import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';

import 'transaction.dart';

class UnassignedTransactionResource extends Equatable {
  final Transaction transaction;
  final Business business;
  final String error;

  UnassignedTransactionResource.fromJson(Map<String, dynamic> json)
    : transaction = Transaction.fromJson(json['transaction']),
      business = Business.fromJson(json['business']),
      error = '';

  UnassignedTransactionResource.withError(String error)
    : transaction = null,
      business = null,
      error = error;

  @override
  List<Object> get props => [transaction, business, error];

  @override
  String toString() => 'UnassignedTransactionResource { transaction: $transaction, business: $business, error: $error }';
}