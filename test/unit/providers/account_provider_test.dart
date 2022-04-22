import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/account_provider.dart';

void main() {
  group("Account Provider Tests", () {
    late AccountProvider accountProvider;

    setUp(() {
      accountProvider = const AccountProvider();
    });

    test("Updating Account data returns ApiResponse", () async {
      var response = await accountProvider.update(body: {}, accountIdentifier: "accountIdentifier");
      expect(response, isA<ApiResponse>());
    });
  });
}