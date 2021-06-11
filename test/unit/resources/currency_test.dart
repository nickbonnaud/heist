import 'package:flutter_test/flutter_test.dart';
import 'package:heist/resources/helpers/currency.dart';

void main() {
  group("Currency Tests", () {

    test("Currency Helper returns value with dollar sign", () {
      expect(Currency.create(cents: 125), "\$1.25");
    });

    test("Currency Helper returns correct amount if decimal longer than two digits", () {
      expect(Currency.create(cents: 100), "\$1.00");
    });
  });
}