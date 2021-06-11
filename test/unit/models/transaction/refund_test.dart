import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/transaction/refund.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Refund Tests", () {

    test("Refund can deserialize json", () {
      Map<String, dynamic> json = MockResponses.generateRefund();
      var refund = Refund.fromJson(json: json);
      expect(refund, isA<Refund>());
    });

    test("Refund formats createdAt to DateTime", () {
      Map<String, dynamic> json = MockResponses.generateRefund();
      var refund = Refund.fromJson(json: json);
      expect(refund.createdAt, isA<DateTime>());
    });
  });
}