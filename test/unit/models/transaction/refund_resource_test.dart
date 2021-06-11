import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/transaction/issue.dart';
import 'package:heist/models/transaction/refund.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Refund Resource Tests", () {

    test("Refund Resource can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateRefundResource();
      var refundResource = RefundResource.fromJson(json: json);
      expect(refundResource, isA<RefundResource>());
    });

    test("Refund Resource formats attributes", () {
      final Map<String, dynamic> json = MockResponses.generateRefundResource();
      var refundResource = RefundResource.fromJson(json: json);
      expect(refundResource.refund, isA<Refund>());
      expect(refundResource.business, isA<Business>());
      expect(refundResource.transaction, isA<Transaction>());
      expect(refundResource.issue, isA<Issue>());
    });
  });
}