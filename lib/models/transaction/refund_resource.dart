import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';

import 'package:meta/meta.dart';

import 'issue.dart';
import 'refund.dart';
import 'transaction.dart';

class RefundResource extends Equatable {
  final Refund refund;
  final Business business;
  final Transaction transaction;
  final Issue issue;
  final String error;

  RefundResource({
    @required this.refund,
    @required this.business,
    @required this.transaction,
    @required this.issue,
    @required this.error
  });

  static RefundResource fromJson(Map<String, dynamic> json) {
    return RefundResource(
      refund: Refund.fromJson(json['refund']),
      business: Business.fromJson(json['business']),
      transaction: Transaction.fromJson(json['transaction']),
      issue: Issue.fromJson(json['issue']),
      error: ''
    );
  }

  static RefundResource withError(String error) {
    return RefundResource(
      refund: null,
      business: null,
      transaction: null,
      issue: null,
      error: error
    );
  }

  @override
  List<Object> get props => [refund, business, transaction, issue, error];

  @override
  String toString() => 'RefundResource { refund: $refund, business: $business, transaction: $transaction, issue: $issue, error: $error }';
}