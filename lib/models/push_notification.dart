import 'package:equatable/equatable.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@immutable
class PushNotification extends Equatable {
  final String title;
  final String body;
  final NotificationType type;
  final String? transactionIdentifier;
  final String? businessIdentifier;
  final int? warningsSent;

  const PushNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.transactionIdentifier,
    required this.businessIdentifier,
    required this.warningsSent
  });

  PushNotification.fromOsNotification({required OSNotification notification})
    : title = notification.title!,
      body = notification.body!,
      type = typeToEnum(jsonType: notification.additionalData!['type']),
      transactionIdentifier = notification.additionalData?['transaction_identifier'],
      businessIdentifier = notification.additionalData?['business_identifier'],
      warningsSent = notification.additionalData?['warnings_sent'];

  PushNotification.fromOsNotificationOpened({required OSNotificationOpenedResult interaction})
    : title = interaction.notification.title!,
      body = interaction.notification.body!,
      type = typeToEnum(jsonType: interaction.notification.additionalData!['type']),
      transactionIdentifier = interaction.notification.additionalData?['transaction_identifier'],
      businessIdentifier = interaction.notification.additionalData?['business_identifier'],
      warningsSent = interaction.notification.additionalData?['warnings_sent'];

  static NotificationType typeToEnum({required String jsonType}) {
    NotificationType type;
    
    switch (jsonType) {
      case 'enter':
        type = NotificationType.enter;
        break;
      case 'exit':
        type = NotificationType.exit;
        break;
      case 'bill_closed':
        type = NotificationType.bill_closed;
        break;
      case 'auto_paid':
        type = NotificationType.auto_paid;
        break;
      case 'fix_bill':
        type = NotificationType.fix_bill;
        break;
      default:
        type = NotificationType.other;
    }
    return type;
  }

  @override
  List<Object?> get props => [title, body, type, transactionIdentifier, businessIdentifier, warningsSent];

  @override
  String toString() => '''PushNotification {
    title: $title,
    body: $body,
    type: $type,
    transactionIdentifier: $transactionIdentifier,
    businessIdentifier: $businessIdentifier,
    warningsSent: $warningsSent
  }''';
}