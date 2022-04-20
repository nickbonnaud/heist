import 'package:equatable/equatable.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:meta/meta.dart';

@immutable
class Refund extends Equatable {
  final String identifier;
  final int total;
  final String status;
  final DateTime createdAt;

  const Refund({
    required this.identifier,
    required this.total,
    required this.status,
    required this.createdAt
  });

  Refund.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      total = json['total'],
      status = json['status'],
      createdAt = DateFormatter.toDateTime(date: json['created_at']);

  @override
  List<Object> get props => [identifier, total, status, createdAt];

  @override
  String toString() => 'Refund { identifier: $identifier, total: $total, status: $status, createdAt: $createdAt }';
}