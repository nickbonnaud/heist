import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/enums/notification_type.dart';

@immutable
class ActiveLocation extends Equatable {
  final String identifier;
  final String beaconIdentifier;
  final String? transactionIdentifier;
  final NotificationType? lastNotification;

  ActiveLocation({
    required this.identifier,
    required this.beaconIdentifier,
    required this.transactionIdentifier,
    required this.lastNotification
  });

  ActiveLocation.fromJson({required Map<String, dynamic> json})
    : identifier = json['active_location_id'],
      beaconIdentifier = json['beacon_identifier'],
      transactionIdentifier = json['transaction_id'],
      lastNotification = json['last_notification'] != null 
        ? _stringToNotificationType(notificationTypeString: json['last_notification'])
        : null;

  static NotificationType _stringToNotificationType({required String notificationTypeString}) {
    return NotificationType.values.firstWhere((notificationType) {
      return notificationType.toString().substring(notificationType.toString().indexOf('.') + 1).toLowerCase() == notificationTypeString.toLowerCase();
    });
  }
  
  @override
  List<Object?> get props => [identifier, beaconIdentifier, transactionIdentifier, lastNotification];

  @override
  String toString() => 'ActiveLocation { identifier: $identifier, beaconIdentifier: $beaconIdentifier, transactionIdentifier: $transactionIdentifier, lastNotification: $lastNotification }';
}