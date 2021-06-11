import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';

import 'package:meta/meta.dart';

import 'issue.dart';
import 'refund.dart';
import 'transaction.dart';

@immutable
class RefundResource extends Equatable {
  final Refund refund;
  final Business business;
  final Transaction transaction;
  final Issue? issue;

  RefundResource({
    required this.refund,
    required this.business,
    required this.transaction,
    required this.issue
  });

  RefundResource.fromJson({required Map<String, dynamic> json})
    : refund = Refund.fromJson(json: json['refund']),
      business = Business.fromJson(json: json['business']),
      transaction = Transaction.fromJson(json: json['transaction']),
      issue = json['issue'] != null
        ? Issue.fromJson(json: json['issue'])
        : null;

  @override
  List<Object?> get props => [refund, business, transaction, issue];

  @override
  String toString() => 'RefundResource { refund: $refund, business: $business, transaction: $transaction, issue: $issue }';
}