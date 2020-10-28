import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'reply.dart';

class HelpTicket extends Equatable {
  final String identifier;
  final String subject;
  final String message;
  final bool read;
  final bool resolved;
  final String updatedAt;
  final List<Reply> replies;
  final String error;

  HelpTicket({
    this.identifier,
    this.subject,
    this.message,
    this.read,
    this.resolved,
    this.updatedAt,
    this.replies,
    this.error
  });

  HelpTicket.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      subject = json['subject'],
      message = json['message'],
      read = json['read'],
      resolved = json['resolved'],
      updatedAt = formatDateTime(dateTime: json['updated_at']),
      replies = (json['replies'] as List).map((jsonReply) => Reply.fromJson(jsonReply)).toList(),
      error = '';

  HelpTicket.withError(String error)
    : identifier = null,
    subject = null,
    message = null,
    read = null,
    resolved = null,
    updatedAt = null,
    replies = null,
    error = error;

  HelpTicket update({
    String identifier,
    String subject,
    String message,
    bool read,
    bool resolved,
    String updatedAt,
    List<Reply> replies
  }) {
    return _copyWith(
      identifier: identifier,
      subject: subject,
      message: message,
      read: read,
      resolved: resolved,
      updatedAt: updatedAt,
      replies: replies
    );
  }
  
  HelpTicket _copyWith({
    String identifier,
    String subject,
    String message,
    bool read,
    bool resolved,
    String updatedAt,
    List<Reply> replies
  }) {
    return HelpTicket(
      identifier: identifier ?? this.identifier,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      read: read ?? this.read,
      resolved: resolved ?? this.resolved,
      updatedAt: updatedAt ?? this.updatedAt,
      replies: replies ?? this.replies
    );
  }

  static String formatDateTime({@required String dateTime}) {
    return DateFormat('dd MMM').add_jm()
      .format(DateTime.parse(dateTime));
  }

  @override
  List<Object> get props => [identifier, subject, message, read, resolved, updatedAt, replies];

  @override
  String toString() => 'HelpTicket { identifier: $identifier, subject: $subject, message: $message, read: $read, resolved: $resolved, updatedAt: $updatedAt, replies: $replies }';
}