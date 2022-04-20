import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/date_formatter.dart';

@immutable
class Issue extends Equatable {
  final String identifier;
  final IssueType type;
  final String message;
  final bool resolved;
  final int warningsSent;
  final DateTime updatedAt;

  const Issue({
    required this.identifier,
    required this.type,
    required this.message,
    required this.resolved,
    required this.warningsSent,
    required this.updatedAt
  });

  String get typeToString => type.toString().substring(type.toString().indexOf('.') + 1).toLowerCase();

  Issue.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      type = typeToEnum(jsonType: json['type']),
      message = json['issue'],
      resolved = json['resolved'],
      warningsSent = json['warnings_sent'],
      updatedAt = DateFormatter.toDateTime(date: json['updated_at']);

  static IssueType typeToEnum({required String jsonType}) {
    if (jsonType == 'wrong_bill') {
      return IssueType.wrongBill;
    } else if (jsonType == 'error_in_bill') {
      return IssueType.errorInBill;
    } else {
      return IssueType.other;
    }
  }

  static String enumToString({required IssueType type}) {
    if (type == IssueType.wrongBill) {
      return 'wrong_bill';
    } else if (type == IssueType.errorInBill) {
      return 'error_in_bill';
    } else {
      return 'other';
    }
  }

  Issue update({
    IssueType? type,
    String? message,
    bool? resolved,
    int? warningsSent,
    DateTime? updatedAt,
  }) => Issue(
    identifier: identifier,
    type: type ?? this.type,
    message: message ?? this.message,
    resolved: resolved ?? this.resolved,
    warningsSent: warningsSent ?? this.warningsSent,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object> get props => [identifier, type, message, resolved, warningsSent, updatedAt];

  @override
  String toString() => '''Issue {
    identifier: $identifier,
    type: $type,
    message: $message,
    resolved: $resolved,
    warningsSent: $warningsSent,
    updatedAt: $updatedAt,
  }''';
}