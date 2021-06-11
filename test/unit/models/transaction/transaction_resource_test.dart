import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/transaction/issue.dart';
import 'package:heist/models/transaction/refund.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Transaction Resource Tests", () {

    test("Transaction Resource can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateTransactionResource();
      var transactionResource = TransactionResource.fromJson(json: json);
      expect(transactionResource, isA<TransactionResource>());
    });

    test("Transaction Resource can formats attributes", () {
      final Map<String, dynamic> json = MockResponses.generateTransactionResource();
      var transactionResource = TransactionResource.fromJson(json: json);
      expect(transactionResource.refunds, isA<List<Refund>>());
      expect(transactionResource.business, isA<Business>());
      expect(transactionResource.transaction, isA<Transaction>());
      expect(transactionResource.issue, isA<Issue>());
    });

    test("Transaction Resource can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateTransactionResource();
      var transactionResource = TransactionResource.fromJson(json: json);
      
      final Transaction transaction = Transaction.fromJson(json: MockResponses.generateTransaction());
      expect(transactionResource.transaction == transaction, false);

      transactionResource = transactionResource.update(transaction: transaction);
      expect(transactionResource.transaction == transaction, true);
    });
  });
}