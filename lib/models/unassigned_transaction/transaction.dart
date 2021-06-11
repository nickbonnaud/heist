import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:meta/meta.dart';

@immutable
class Transaction extends Equatable {
  final String identifier;
  final int tax;
  final int netSales;
  final int total;
  final DateTime createdDate;
  final DateTime updatedDate;
  final List<PurchasedItem> purchasedItems;

  Transaction({
    required this.identifier,
    required this.tax,
    required this.netSales,
    required this.total,
    required this.createdDate,
    required this.updatedDate,
    required this.purchasedItems
  });

  Transaction.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      tax = json['tax'],
      netSales = json['net_sales'],
      total = json['total'],
      createdDate = DateFormatter.toDateTime(date: json['created_at']),
      updatedDate = DateFormatter.toDateTime(date: json['updated_at']),
      purchasedItems = (json['purchased_items'] as List).map((jsonPurchasedItem) {
        return PurchasedItem.fromJson(json: jsonPurchasedItem);
      }).toList();

  @override
  List<Object> get props => [identifier, tax, netSales, total, createdDate, updatedDate, purchasedItems];

  @override
  String toString() => 'Transaction { identifier: $identifier, tax: $tax, netSales: $netSales, total: $total, createdDate: $createdDate, updatedDate: $updatedDate, purchasedItems: $purchasedItems }';
}