import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/business/business.dart';

import 'transaction.dart';

@immutable
class UnassignedTransactionResource extends Equatable {
  final Transaction transaction;
  final Business business;

  UnassignedTransactionResource.fromJson({required Map<String, dynamic> json})
    : transaction = Transaction.fromJson(json: json['transaction']),
      business = Business.fromJson(json: json['business']);

  @override
  List<Object> get props => [transaction, business];

  @override
  String toString() => 'UnassignedTransactionResource { transaction: $transaction, business: $business }';
}