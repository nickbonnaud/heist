import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Reply extends Equatable {
  final String message;
  final bool fromCustomer;
  final String createdAt;
  final bool read;
  final String error;

  Reply({this.message, this.fromCustomer, this.createdAt, this.read, this.error});

  Reply.fromJson(Map<String, dynamic> json)
    : message = json['message'],
      fromCustomer = json['from_customer'],
      createdAt = formatDateTime(dateTime: json['created_at']),
      read = json['read'],
      error = "";

  Reply.withError(String error)
    : message = null,
      fromCustomer = null,
      createdAt = null,
      read = null,
      error = error;

  Reply update({String message, bool fromCustomer, String createdAt, bool read}) {
    return _copyWith(message: message, fromCustomer: fromCustomer, createdAt: createdAt, read: read);
  }
  
  Reply _copyWith({String message, bool fromCustomer, String createdAt, bool read}) {
    return Reply(
      message: message ?? this.message,
      fromCustomer: fromCustomer ?? this.fromCustomer,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      error: ''
    );
  }
  
  static String formatDateTime({@required String dateTime}) {
    return DateFormat('dd MMM').add_jm()
      .format(DateTime.parse(dateTime));
  }

  @override
  List<Object> get props => [message, fromCustomer, createdAt, read, error];

  @override
  String toString() => 'Reply { message: $message, fromCustomer: $fromCustomer, createdAt: $createdAt, read: $read, error: $error }';
}