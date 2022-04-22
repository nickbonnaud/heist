import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/resources/enums/notification_type.dart';

@immutable
class ActiveLocation extends Equatable {
  final String identifier;
  final Business business;
  final String? transactionIdentifier;
  final NotificationType? lastNotification;

  const ActiveLocation({
    required this.identifier,
    required this.business,
    required this.transactionIdentifier,
    required this.lastNotification
  });

  ActiveLocation.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      business = Business.fromJson(json: json['business']),
      transactionIdentifier = json['transaction_id'],
      lastNotification = json['last_notification'] != null 
        ? _stringToNotificationType(notificationTypeString: json['last_notification'])
        : null;

  static NotificationType _stringToNotificationType({required String notificationTypeString}) {
    switch (notificationTypeString) {
      case 'auto_paid':
        return NotificationType.autoPaid;
      case 'bill_closed':
        return NotificationType.billClosed;
      case 'enter':
        return NotificationType.enter;
      case 'exit':
        return NotificationType.exit;
      case 'fix_bill':
        return NotificationType.fixBill;
      case 'other':
        return NotificationType.other;
      default:
        return NotificationType.other;
    }
  }

  ActiveLocation update({String? transactionIdentifier, NotificationType? lastNotification}) {
    return ActiveLocation(
      identifier: identifier,
      business: business,
      transactionIdentifier: transactionIdentifier ?? this.transactionIdentifier,
      lastNotification: lastNotification ?? this.lastNotification
    );
  }
  
  @override
  List<Object?> get props => [identifier, business, transactionIdentifier, lastNotification];

  @override
  String toString() => 'ActiveLocation { identifier: $identifier, business: $business, transactionIdentifier: $transactionIdentifier, lastNotification: $lastNotification }';
}