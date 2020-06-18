import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'purchased_item.dart';
import 'status.dart';

class Transaction extends Equatable {
  final String identifier;
  final int tax;
  final int tip;
  final int netSales;
  final int total;
  final String billCreatedAt;
  final String billUpdatedAt;
  final Status status;
  final bool locked;
  final List<PurchasedItem> purchasedItems;

  Transaction({
    @required this.identifier,
    @required this.tax,
    @required this.tip,
    @required this.netSales,
    @required this.total,
    @required this.billCreatedAt,
    @required this.billUpdatedAt,
    @required this.status,
    @required this.locked,
    @required this.purchasedItems
  });

  static Transaction fromJson(Map<String, dynamic> json) {
    Transaction transaction = Transaction(
      identifier: json['identifier'],
      tax: int.parse(json['tax']),
      tip: int.parse(json['tip']),
      netSales: int.parse(json['net_sales']),
      total: int.parse(json['total']),
      billCreatedAt: DateFormat('E, MMM d').format(DateTime.parse(json['bill_created_at'])),
      billUpdatedAt: DateFormat('E, MMM d').format(DateTime.parse(json['updated_at'])),
      status: Status.fromJson(json['status']),
      locked: json['locked'],
      purchasedItems: (json['purchased_items'] as List).map((jsonPurchasedItem) {
        return PurchasedItem.fromJson(jsonPurchasedItem);
      }).toList()
    );
    return transaction;
  }

  Transaction update({
    String identifier,
    int tax,
    int tip,
    int netSales,
    int total,
    String billCreatedAt,
    String billUpdatedAt,
    Status status,
    bool locked,
    List<PurchasedItem> purchasedItems
  }) {
    return _copyWith(
      identifier: identifier,
      tax: tax,
      tip: tip,
      netSales: netSales,
      total: total,
      billCreatedAt: billCreatedAt,
      billUpdatedAt: billUpdatedAt,
      status: status,
      locked: locked,
      purchasedItems: purchasedItems
    );
  }
  
  Transaction _copyWith({
    String identifier,
    int tax,
    int tip,
    int netSales,
    int total,
    String billCreatedAt,
    String billUpdatedAt,
    Status status,
    bool locked,
    List<PurchasedItem> purchasedItems
  }) {
    return Transaction(
      identifier: identifier ?? this.identifier,
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
  }

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