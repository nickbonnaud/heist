import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/customer_provider.dart';

void main() {
  group("Customer Provider Tests", () {
    late CustomerProvider customerProvider;

    setUp(() {
      customerProvider = CustomerProvider();
    });

    test("Fetching customer returns ApiResponse", () async {
      var response = await customerProvider.fetchCustomer();
      expect(response, isA<ApiResponse>());
    });

    test("Updating email returns ApiResponse", () async {
      var response = await customerProvider.updateEmail(body: {}, customerId: "customerId");
      expect(response, isA<ApiResponse>());
    });

    test("Updating password returns ApiResponse", () async {
      var response = await customerProvider.updatePassword(body: {}, customerId: "customerId");
      expect(response, isA<ApiResponse>());
    });
  });
}