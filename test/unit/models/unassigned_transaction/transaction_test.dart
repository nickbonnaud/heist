import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/unassigned_transaction/transaction.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Transaction Tests", () {

    test("Transaction can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateTransactionForUnassignedTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction, isA<Transaction>());
    });

    test("Transaction formats dates to DateTime", () {
      final Map<String, dynamic> json = MockResponses.generateTransactionForUnassignedTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction.createdDate, isA<DateTime>());
      expect(transaction.updatedDate, isA<DateTime>());
    });
  });
}