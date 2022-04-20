
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/resources/http/mock_responses.dart';
import 'package:mocktail/mocktail.dart';

class MockBusiness extends Mock implements Business {}

void main() {
  group("Active Location Tests", () {
    
    test("Active Location can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateActiveLocation();
      var activeLocation = ActiveLocation.fromJson(json: json);
      expect(activeLocation, isA<ActiveLocation>());
    });

    test("Active Location can convert string to enum NotificationType", () {
      Map<String, dynamic> json = MockResponses.generateActiveLocation();
      while (json['last_notification'] == null) {
        json = MockResponses.generateActiveLocation();
      }

      var activeLocation = ActiveLocation.fromJson(json: json);
      expect(activeLocation.lastNotification, isA<NotificationType>());
    });

    test("Active Location can update it's values", () {
      final ActiveLocation activeLocation = ActiveLocation(
        identifier: faker.guid.guid(),
        business: MockBusiness(),
        transactionIdentifier: null,
        lastNotification: null
      );

      final ActiveLocation updatedActiveLocation = activeLocation.update(
        transactionIdentifier: faker.guid.guid(),
        lastNotification: NotificationType.billClosed
      );

      expect(activeLocation != updatedActiveLocation, true);
    });
  });
}