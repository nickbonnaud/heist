import 'package:equatable/equatable.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/transaction/refund.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:meta/meta.dart';

class RefundResource extends Equatable {
  final Refund refund;
  final Business business;
  final Transaction transaction;
  final String error;

  RefundResource({@required this.refund, @required this.business, @required this.transaction, @required this.error});

  static RefundResource fromJson(Map<String, dynamic> json) {
    return RefundResource(
      refund: Refund.fromJson(json['refund']),
      business: Business.fromJson(json['business']),
      transaction: Transaction.fromJson(json['transaction']),
      error: ''
    );
  }

  static RefundResource withError(String error) {
    return RefundResource(
      refund: null,
      business: null,
      transaction: null,
      error: error
    );
  }

  @override
  List<Object> get props => [refund, business, transaction, error];

  @override
  String toString() => 'RefundResource { refund: $refund, business: $business, transaction: $transaction, error: $error }';
}