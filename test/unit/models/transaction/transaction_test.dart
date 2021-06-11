import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/status.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/models/transaction/transaction.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Transaction Tests", () {

    test("Transaction can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction, isA<Transaction>());
    });

    test("Transaction formats dates to DateTime", () {
      final Map<String, dynamic> json = MockResponses.generateTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction.billCreatedAt, isA<DateTime>());
      expect(transaction.billUpdatedAt, isA<DateTime>());
    });

    test("Transaction formats status to Status", () {
      final Map<String, dynamic> json = MockResponses.generateTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction.status, isA<Status>());
    });

    test("Transaction formats purchased items to List<PurchasedItems>", () {
      final Map<String, dynamic> json = MockResponses.generateTransaction();
      var transaction = Transaction.fromJson(json: json);
      expect(transaction.purchasedItems, isA<List<PurchasedItem>>());
    });

    test("Transaction can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateTransaction();
      var transaction = Transaction.fromJson(json: json);
      
      final int statusCode = 500;
      final Status status = Status(name: "error", code: statusCode);

      expect(transaction.status.code == statusCode, false);

      transaction = transaction.update(status: status);
      expect(transaction.status.code == statusCode, true);
    });
  });
}