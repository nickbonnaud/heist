import 'package:equatable/equatable.dart';
import 'package:heist/models/status.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:meta/meta.dart';

import 'purchased_item.dart';

@immutable
class Transaction extends Equatable {
  final String identifier;
  final int tax;
  final int tip;
  final int netSales;
  final int total;
  final DateTime billCreatedAt;
  final DateTime billUpdatedAt;
  final Status status;
  final bool locked;
  final List<PurchasedItem> purchasedItems;

  Transaction({
    required this.identifier,
    required this.tax,
    required this.tip,
    required this.netSales,
    required this.total,
    required this.billCreatedAt,
    required this.billUpdatedAt,
    required this.status,
    required this.locked,
    required this.purchasedItems
  });

  Transaction.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      tax = json['tax'],
      tip = json['tip'],
      netSales = json['net_sales'],
      total = json['total'],
      billCreatedAt = DateFormatter.toDateTime(date: json['bill_created_at']),
      billUpdatedAt = DateFormatter.toDateTime(date: json['updated_at']),
      status = Status.fromJson(json: json['status']),
      locked = json['locked'],
      purchasedItems = (json['purchased_items'] as List).map((jsonPurchasedItem) {
        return PurchasedItem.fromJson(json: jsonPurchasedItem);
      }).toList();

  Transaction update({
    int? tax,
    int? tip,
    int? netSales,
    int? total,
    DateTime? billCreatedAt,
    DateTime? billUpdatedAt,
    Status? status,
    bool? locked,
    List<PurchasedItem>? purchasedItems
  }) => Transaction(
    identifier: this.identifier,
    tax: tax ?? this.tax,
    tip: tip ?? this.tip,
    netSales: netSales ?? this.netSales,
    total: total ?? this.total,
    billCreatedAt: billCreatedAt ?? this.billCreatedAt,
    billUpdatedAt: billUpdatedAt ?? this.billUpdatedAt,
    status: status ?? this.status,
    locked: locked ?? this.locked,
    purchasedItems: purchasedItems ?? this.purchasedItems
  );

  @override
  List<Object> get props => [
    identifier,
    tax,
    tip,
    netSales,
    total,
    billCreatedAt,
    billUpdatedAt,
    status,
    locked,
    purchasedItems
  ];

  @override 
  String toString() => '''Transaction {
    identifier: $identifier,
    tax: $tax,
    tip: $tip,
    netSales: $netSales,
    total: $total,
    billCreatedAt: $billCreatedAt,
    billUpdatedAt: $billUpdatedAt,
    status: $status,
    locked: $locked,
    purchasedItems: $purchasedItems
  }''';
}