import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/account.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/providers/account_provider.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountProvider extends Mock implements AccountProvider {}

void main() {
  group("Account Repository Tests", () {
    late AccountRepository accountRepository;
    late AccountProvider mockAccountProvider;
    late AccountRepository accountRepositoryWithMock;

    setUp(() {
      accountRepository = const AccountRepository();
      mockAccountProvider = MockAccountProvider();
      accountRepositoryWithMock = AccountRepository(accountProvider: mockAccountProvider);
    });

    test("Account Repository can update customer account", () async {
      var customer = await accountRepository.update(
        accountIdentifier: faker.guid.guid(),
        tipRate: 20,
        quickTipRate: 10,
        primary: "ach"
      );

      expect(customer, isA<Customer>());
      expect(customer.account.tipRate, 20);
      expect(customer.account.quickTipRate, 10);
      expect(customer.account.primary, PrimaryType.ach);
    });

    test("Account Repository throws error on update fail", () async {
      when(() => mockAccountProvider.update(body: any(named: 'body'), accountIdentifier: any(named: "accountIdentifier")))
        .thenAnswer((_) async => const ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        accountRepositoryWithMock.update(
          accountIdentifier: "accountIdentifier",
          tipRate: 18
        ), 
        throwsA(isA<ApiException>()));
    });
  });
}