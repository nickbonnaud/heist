import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/transaction/purchased_item.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Purchased Item Tests", () {

    test("Purchased Item can deserialize json", () {
      Map<String, dynamic> json = MockResponses.generatePurchasedItem();
      var purchasedItem = PurchasedItem.fromJson(json: json);
      expect(purchasedItem, isA<PurchasedItem>());
    });
  });
}