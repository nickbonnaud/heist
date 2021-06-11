import 'package:equatable/equatable.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:meta/meta.dart';

@immutable
class Reply extends Equatable {
  final String message;
  final bool fromCustomer;
  final DateTime createdAt;
  final bool read;

  Reply({
    required this.message,
    required this.fromCustomer,
    required this.createdAt,
    required this.read
  });

  Reply.fromJson({required Map<String, dynamic> json})
    : message = json['message'],
      fromCustomer = json['from_customer'],
      createdAt = DateFormatter.toDateTime(date: json['created_at']),
      read = json['read'];


  Reply update({
    String? message,
    bool? fromCustomer,
    DateTime? createdAt,
    bool? read
  }) => Reply(
    message: message ?? this.message,
    fromCustomer: fromCustomer ?? this.fromCustomer,
    createdAt: createdAt ?? this.createdAt,
    read: read ?? this.read
  );

  @override
  List<Object> get props => [message, fromCustomer, createdAt, read];

  @override
  String toString() => 'Reply { message: $message, fromCustomer: $fromCustomer, createdAt: $createdAt, read: $read }';
}