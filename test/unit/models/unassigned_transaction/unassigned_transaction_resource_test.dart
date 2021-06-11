import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/unassigned_transaction/transaction.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Unassigned Transaction Resource Tests", () {
    
    test("Unassigned Transaction Resource can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateUnassignedTransactionResource();
      var unassignedTransactionResource = UnassignedTransactionResource.fromJson(json: json);
      expect(unassignedTransactionResource, isA<UnassignedTransactionResource>());
    });

    test("Unassigned Transaction Resource formats attributes", () {
      final Map<String, dynamic> json = MockResponses.generateUnassignedTransactionResource();
      var unassignedTransactionResource = UnassignedTransactionResource.fromJson(json: json);
      expect(unassignedTransactionResource.transaction, isA<Transaction>());
      expect(unassignedTransactionResource.business, isA<Business>());
    });
  });
}