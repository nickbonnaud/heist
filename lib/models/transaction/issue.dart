import 'package:equatable/equatable.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Issue extends Equatable {
  final String identifier;
  final IssueType type;
  final String message;
  final bool resolved;
  final int warningsSent;
  final String updatedAt;
  final String formattedUpdatedAt;

  Issue({
    @required this.identifier,
    @required this.type,
    @required this.message,
    @required this.resolved,
    @required this.warningsSent,
    @required this.updatedAt,
    @required this.formattedUpdatedAt
  });

  static Issue fromJson(Map<String, dynamic> json) {
    return Issue(
      identifier: json['identifier'],
      type: typeToEnum(json['type']),
      message: json['issue'],
      resolved: json['resolved'],
      warningsSent: int.parse(json['warnings_sent']),
      updatedAt: json['updated_at'],
      formattedUpdatedAt: _formatDate(json['updated_at'])
    );
  }

  static String _formatDate(String date) {
    return DateFormat('E, MMM d').format(DateTime.parse(date));
  }

  static IssueType typeToEnum(String jsonType) {
    if (jsonType == 'wrong_bill') {
      return IssueType.wrong_bill;
    } else if (jsonType == 'error_in_bill') {
      return IssueType.error_in_bill;
    } else {
      return IssueType.other;
    }
  }

  static String enumToString(IssueType type) {
    if (type == IssueType.wrong_bill) {
      return 'wrong_bill';
    } else if (type == IssueType.error_in_bill) {
      return 'error_in_bill';
    } else {
      return 'other';
    }
  }

  Issue update({
    String identifier,
    IssueType type,
    String message,
    bool resolved,
    int warningsSent,
    String updatedAt,
    String formattedUpdatedAt
  }) {
    return _copyWith(
      identifier: identifier,
      type: type,
      message: message,
      resolved: resolved,
      warningsSent: warningsSent,
      updatedAt: updatedAt,
      formattedUpdatedAt: formattedUpdatedAt
    );
  }
  
  Issue _copyWith({
    String identifier,
    IssueType type,
    String message,
    bool resolved,
    int warningsSent,
    String updatedAt,
    String formattedUpdatedAt
  }) {
    return Issue(
      identifier: identifier ?? this.identifier,
      type: type ?? this.type,
      message: message ?? this.message,
      resolved: resolved ?? this.resolved,
      warningsSent: warningsSent ?? this.warningsSent,
      updatedAt: updatedAt ?? this.updatedAt,
      formattedUpdatedAt: formattedUpdatedAt ?? this.formattedUpdatedAt
    );
  }

  @override
  List<Object> get props => [identifier, type, message, resolved, warningsSent, updatedAt, formattedUpdatedAt];

  @override
  String toString() => '''Issue {
    identifier: $identifier,
    type: $type,
    message: $message,
    resolved: $resolved,
    warningsSent: $warningsSent,
    updatedAt: $updatedAt,
    formattedUpdatedAt: $formattedUpdatedAt
  }''';
}