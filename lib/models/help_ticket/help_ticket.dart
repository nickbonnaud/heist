import 'package:equatable/equatable.dart';
import 'package:heist/resources/helpers/date_formatter.dart';
import 'package:meta/meta.dart';

import 'reply.dart';

@immutable
class HelpTicket extends Equatable {
  final String identifier;
  final String subject;
  final String message;
  final bool read;
  final bool resolved;
  final DateTime updatedAt;
  final List<Reply> replies;

  HelpTicket({
    required this.identifier,
    required this.subject,
    required this.message,
    required this.read,
    required this.resolved,
    required this.updatedAt,
    required this.replies,
  });

  HelpTicket.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      subject = json['subject'],
      message = json['message'],
      read = json['read'],
      resolved = json['resolved'],
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']),
      replies = (json['replies'] as List).map((jsonReply) => Reply.fromJson(json: jsonReply)).toList();

  HelpTicket update({
    String? subject,
    String? message,
    bool? read,
    bool? resolved,
    DateTime? updatedAt,
    List<Reply>? replies
  }) => HelpTicket(
    identifier: this.identifier,
    subject: subject ?? this.subject,
    message: message ?? this.message,
    read: read ?? this.read,
    resolved: resolved ?? this.resolved,
    updatedAt: updatedAt ?? this.updatedAt,
    replies: replies ?? this.replies
  );

  @override
  List<Object> get props => [identifier, subject, message, read, resolved, updatedAt, replies];

  @override
  String toString() => 'HelpTicket { identifier: $identifier, subject: $subject, message: $message, read: $read, resolved: $resolved, updatedAt: $updatedAt, replies: $replies }';
}