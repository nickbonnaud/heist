import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/http/mock_responses.dart';

main() {
  group("Customer Tests", () {
    test("Customer can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateCustomer();
      var customer = Customer.fromJson(json: json);
      expect(customer, isA<Customer>());
    });

    test("Customer can update it's attributes", () {
      final Map<String, dynamic> json = MockResponses.generateCustomer();
      var customer = Customer.fromJson(json: json);
      
      final String email = faker.internet.email();
      expect(customer.email == email, false);

      customer = customer.update(email: email);
      expect(customer.email == email, true);
    });
  });
}