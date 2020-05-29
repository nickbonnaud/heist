import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:meta/meta.dart';

import 'issue.dart';
import 'refund.dart';
import 'transaction.dart';

class TransactionResource extends Equatable {
  final Transaction transaction;
  final Business business;
  final List<Refund> refunds;
  final Issue issue;
  final String error;

  TransactionResource({
    @required this.transaction, 
    @required this.business, 
    @required this.refunds, 
    @required this.issue,
    @required this.error
  });

  static TransactionResource fromJson(Map<String, dynamic> json) {
    return TransactionResource(
      transaction: Transaction.fromJson(json['transaction']),
      business: Business.fromJson(json['business']),
      refunds: (json['refund'] as List).map((jsonRefund) {
        return Refund.fromJson(jsonRefund);
      }).toList(),
      issue: json['issue'] != null ? Issue.fromJson(json['issue']) : null,
      error: ''
    );
  }

  static TransactionResource withError(String error) {
    return TransactionResource(
      transaction: null,
      business: null,
      refunds: null,
      issue: null,
      error: error
    );
  }

  @override
  List<Object> get props => [transaction, business, refunds, issue, error];

  @override
  String toString() => 'TransactionResource { transaction: $transaction, business: $business, refunds: $refunds, issue: $issue, error: $error }';
}