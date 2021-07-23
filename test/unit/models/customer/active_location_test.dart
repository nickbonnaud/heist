
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/resources/http/mock_responses.dart';

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
  });
}