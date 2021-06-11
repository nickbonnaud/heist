import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PurchasedItem extends Equatable {
  final String name;
  final String? subName;
  final int price;
  final int quantity;
  final int total;

  PurchasedItem({
    required this.name,
    required this.subName,
    required this.price,
    required this.quantity,
    required this.total
  });

  PurchasedItem.fromJson({required Map<String, dynamic> json})
    : name = json['name'], 
      subName = json['sub_name'],
      price = json['price'],
      quantity = json['quantity'],
      total = json['total'];

  @override
  List<Object?> get props => [name, subName, price, quantity, price];

  @override
  String toString() => 'PurchasedItem { name: $name, subName: $subName, price: $price, quantity: $quantity, total: $total }';
}