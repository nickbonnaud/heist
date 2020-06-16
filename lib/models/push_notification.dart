import 'package:equatable/equatable.dart';
import 'package:heist/resources/enums/notification_typ.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotification extends Equatable {
  final String title;
  final String body;
  final NotificationType type;
  final String transactionIdentifier;
  final String businessIdentifier;
  final int numberErrorWarnings;

  const PushNotification({
    @required this.title,
    @required this.body,
    @required this.type,
    @required this.transactionIdentifier,
    @required this.businessIdentifier,
    @required this.numberErrorWarnings
  });

  static PushNotification fromOsNotification({@required OSNotification notification}) {
    return PushNotification(
      title: notification.payload.title,
      body: notification.payload.body,
      type: typeToEnum(notification.payload.additionalData['type']),
      transactionIdentifier: notification.payload.additionalData['transaction_identifier'],
      businessIdentifier: notification.payload.additionalData['business_identifier'],
      numberErrorWarnings: notification.payload.additionalData['numberErrorWarnings'].toString() != 'null' ? int.parse(notification.payload.additionalData['numberErrorWarnings']) : null
    );
  }

  static PushNotification fromOsNotificationOpened({@required OSNotificationOpenedResult interaction}) {
    return PushNotification(
      title: interaction.notification.payload.title,
      body: interaction.notification.payload.body,
      type: typeToEnum(interaction.notification.payload.additionalData['type']),
      transactionIdentifier: interaction.notification.payload.additionalData['transaction_identifier'],
      businessIdentifier: interaction.notification.payload.additionalData['business_identifier'],
      numberErrorWarnings: interaction.notification.payload.additionalData['numberErrorWarnings'].toString() != 'null' ? int.parse(interaction.notification.payload.additionalData['numberErrorWarnings']) : null
    );
  }

  static NotificationType typeToEnum(String jsonType) {
    NotificationType type;
    switch (jsonType) {
      case 'enter':
        type = NotificationType.enter;
        break;
      case 'exit':
        type = NotificationType.exit;
        break;
      case 'request_payment':
        type = NotificationType.request_payment;
        break;
      case 'auto_paid':
        type = NotificationType.auto_paid;
        break;
      case 'auto_paid_with_error':
        type = NotificationType.auto_paid_with_error;
        break;
    }
    return type;
  }

  @override
  List<Object> get props => [title, body, type, transactionIdentifier, businessIdentifier, numberErrorWarnings];

  @override
  String toString() => '''PushNotification {
    title: $title,
    body: $body,
    type: $type,
    transactionIdentifier: $transactionIdentifier,
    businessIdentifier: $businessIdentifier,
    numberErrorWarnings: $numberErrorWarnings
  }''';
}