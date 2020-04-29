import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Refund extends Equatable {
  final String identifier;
  final int total;
  final String status;
  final String createdAt;

  Refund({@required this.identifier, @required this.total, @required this.status, @required this.createdAt});

  static Refund fromJson(Map<String, dynamic> json) {
    return Refund(
      identifier: json['identifier'],
      total: int.parse(json['total']),
      status: json['status'],
      createdAt: DateFormat('E, MMM d').format(DateTime.parse(json['created_at']))
    );
  }

  @override
  List<Object> get props => [identifier, total, status, createdAt];

  @override
  String toString() => 'Refund { identifier: $identifier, total: $total, status: $status, createdAt: $createdAt }';
}