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

  ActiveLocation({
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
    return NotificationType.values.firstWhere((notificationType) {
      return notificationType.toString().substring(notificationType.toString().indexOf('.') + 1).toLowerCase() == notificationTypeString.toLowerCase();
    });
  }

  ActiveLocation update({String? transactionIdentifier, NotificationType? lastNotification}) {
    return ActiveLocation(
      identifier: this.identifier,
      business: this.business,
      transactionIdentifier: transactionIdentifier ?? this.transactionIdentifier,
      lastNotification: lastNotification ?? this.lastNotification
    );
  }
  
  @override
  List<Object?> get props => [identifier, business, transactionIdentifier, lastNotification];

  @override
  String toString() => 'ActiveLocation { identifier: $identifier, business: $business, transactionIdentifier: $transactionIdentifier, lastNotification: $lastNotification }';
}