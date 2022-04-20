import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/customer/account.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Account Tests", () {

    test("Account can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateAccount();
      var account = Account.fromJson(json: json);
      expect(account, isA<Account>());
    });

    test("Account can create an empty placeholder", () {
      var account = const Account.empty();
      expect(account, isA<Account>());
    });

    test("Account can convert string primary type to enum PrimaryType", () {
      final Map<String, dynamic> json = MockResponses.generateAccount();
      var account = Account.fromJson(json: json);
      expect(account.primary, isA<PrimaryType>());
    });

    test("Account can convert enum PrimaryType to string", () {
      final Map<String, dynamic> json = MockResponses.generateAccount();
      var account = Account.fromJson(json: json);
      expect(account.primaryToString, isA<String>());
    });

    test("Account can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateAccount();
      var account = Account.fromJson(json: json);
      final int newTipRate = account.tipRate + 3;
      final PrimaryType newPrimaryType = account.primary == PrimaryType.ach ? PrimaryType.credit : PrimaryType.ach;

      account = account.update(tipRate: newTipRate, primary: newPrimaryType);
      expect(account.tipRate, newTipRate);
      expect(account.primary, newPrimaryType);
    });
  });
}