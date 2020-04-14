import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:meta/meta.dart';

import 'refund.dart';
import 'transaction.dart';

class TransactionResource extends Equatable {
  final Transaction transaction;
  final Business business;
  final List<Refund> refund;
  final String error;

  TransactionResource({@required this.transaction, @required this.business, @required this.refund, @required this.error});

  static TransactionResource fromJson(Map<String, dynamic> json) {
    return TransactionResource(
      transaction: Transaction.fromJson(json['transaction']),
      business: Business.fromJson(json['business']),
      refund: (json['refund'] as List).map((jsonRefund) {
        return Refund.fromJson(jsonRefund);
      }).toList(),
      error: ''
    );
  }

  static TransactionResource withError(String error) {
    return TransactionResource(
      transaction: null,
      business: null,
      refund: null,
      error: error
    );
  }

  @override
  List<Object> get props => [transaction, business, refund, error];

  @override
  String toString() => 'TransactionResource { transaction: $transaction, business: $business, refund: $refund, error: $error }';
}