import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/enums/issue_type.dart';

@immutable
class IssueArgs extends Equatable {
  final IssueType type;
  final TransactionResource transactionResource;

  const IssueArgs({required this.type, required this.transactionResource});

  @override
  List<Object> get props => [type, transactionResource];

  @override
  String toString() => 'IssueArgs { type: $type, transactionResource: $transactionResource }';
}