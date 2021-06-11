import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MockOSNotification extends Mock implements OSNotification {}
class MockOSNotificationOpenedResult extends Mock implements OSNotificationOpenedResult {}

void main() {
  group("Push Notification Tests", () {
    late OSNotification osNotification;
    late OSNotificationOpenedResult osNotificationOpenedResult;

    setUp(() {
      osNotification = MockOSNotification();
      when(() => osNotification.title).thenReturn(faker.lorem.sentence());
      when(() => osNotification.body).thenReturn(faker.lorem.sentence());
      when(() => osNotification.additionalData).thenReturn({
        'type': 'enter',
        'transaction_identifier': faker.randomGenerator.boolean()
          ? faker.guid.guid()
          : null,
        'business_identifier': faker.randomGenerator.boolean()
          ? faker.guid.guid()
          : null,
        'warnings_sent': faker.randomGenerator.boolean()
          ? faker.randomGenerator.integer(3)
          : null,
      });

      osNotificationOpenedResult = MockOSNotificationOpenedResult();
      when(() => osNotificationOpenedResult.notification).thenReturn(osNotification);
    });
    
    test("Push Notification can deserialize OSNotification", () {
      var pushNotification = PushNotification.fromOsNotification(notification: osNotification);
      expect(pushNotification, isA<PushNotification>());
    });

    test("Push Notification from OSNotification converts type string to enum", () {
      var pushNotification = PushNotification.fromOsNotification(notification: osNotification);
      expect(pushNotification.type, isA<NotificationType>());
    });

    test("Push Notification can deserialize OSNotificationOpenedResult", () {
      var pushNotification = PushNotification.fromOsNotificationOpened(interaction: osNotificationOpenedResult);
      expect(pushNotification, isA<PushNotification>());
    });

    test("Push Notification from OSNotificationOpenedResult converts type string to enum", () {
      var pushNotification = PushNotification.fromOsNotificationOpened(interaction: osNotificationOpenedResult);
      expect(pushNotification.type, isA<NotificationType>());
    });
  });
}