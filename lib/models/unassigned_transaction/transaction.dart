import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Transaction extends Equatable {
  final String identifier;
  final int tax;
  final int netSales;
  final int total;
  final String createdDate;
  final String formattedCreatedDate;
  final String updatedDate;
  final String formattedUpdatedDate;
  final List<PurchasedItem> purchasedItems;

  Transaction({
    @required this.identifier,
    @required this.tax,
    @required this.netSales,
    @required this.total,
    @required this.createdDate,
    @required this.formattedCreatedDate,
    @required this.updatedDate,
    @required this.formattedUpdatedDate,
    @required this.purchasedItems
  });

  Transaction.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      tax = int.parse(json['tax']),
      netSales = int.parse(json['net_sales']),
      total = int.parse(json['total']),
      createdDate = json['created_at'],
      formattedCreatedDate = DateFormat('E, MMM d').format(DateTime.parse(json['created_at'])),
      updatedDate = json['updated_at'],
      formattedUpdatedDate = DateFormat('E, MMM d').format(DateTime.parse(json['updated_at'])),
      purchasedItems = (json['purchased_items'] as List).map((jsonPurchasedItem) {
        return PurchasedItem.fromJson(jsonPurchasedItem);
      }).toList();

  @override
  List<Object> get props => [identifier, tax, netSales, total, createdDate, formattedCreatedDate, updatedDate, formattedUpdatedDate, purchasedItems];

  @override
  String toString() => 'Transaction { identifier: $identifier, tax: $tax, netSales: $netSales, total: $total, createdDate: $createdDate, formattedCreatedDate: $formattedCreatedDate, updatedDate: $updatedDate, formattedUpdatedDate: $formattedUpdatedDate, purchasedItems: $purchasedItems }';
}