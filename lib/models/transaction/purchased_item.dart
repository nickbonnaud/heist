import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PurchasedItem extends Equatable {
  final String name;
  final String subName;
  final int price;
  final int quantity;
  final int total;

  PurchasedItem({
    @required this.name,
    @required this.subName,
    @required this.price,
    @required this.quantity,
    @required this.total
  });

  static PurchasedItem fromJson(Map<String, dynamic> json) {
    return PurchasedItem(
      name: json['name'], 
      subName: json['sub_name'].toString() == 'null' ? null : json['sub_name'],
      price: int.parse(json['price']),
      quantity: int.parse(json['quantity']),
      total: int.parse(json['total'])
    );
  }

  @override
  List<Object> get props => [name, subName, price, quantity, price];

  @override
  String toString() => 'PurchasedItem { name: $name, subName: $subName, price: $price, quantity: $quantity, total: $total }';
}