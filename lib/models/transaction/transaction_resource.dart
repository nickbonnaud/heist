import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:meta/meta.dart';

import 'issue.dart';
import 'refund.dart';
import 'transaction.dart';

@immutable
class TransactionResource extends Equatable {
  final Transaction transaction;
  final Business business;
  final List<Refund> refunds;
  final Issue? issue;

  const TransactionResource({
    required this.transaction, 
    required this.business, 
    required this.refunds, 
    required this.issue
  });

  TransactionResource.fromJson({required Map<String, dynamic> json})
    : transaction = Transaction.fromJson(json: json['transaction']),
      business = Business.fromJson(json: json['business']),
      refunds = (json['refunds'] as List).map((jsonRefund) {
        return Refund.fromJson(json: jsonRefund);
      }).toList(),
      issue = json['issue'] != null 
        ? Issue.fromJson(json: json['issue']) 
        : null;

  TransactionResource update({
    Transaction? transaction,
    Business? business,
    List<Refund>? refunds,
    Issue? issue
  }) => TransactionResource(
    transaction: transaction ?? this.transaction,
    business: business ?? this.business,
    refunds: refunds ?? this.refunds,
    issue: issue ?? this.issue,
  );

  @override
  List<Object?> get props => [transaction, business, refunds, issue];

  @override
  String toString() => 'TransactionResource { transaction: $transaction, business: $business, refunds: $refunds, issue: $issue }';
}