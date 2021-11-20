import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/token.dart';
import 'package:heist/providers/customer_provider.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/token_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerProvider extends Mock implements CustomerProvider {}
class MockTokenRepository extends Mock implements TokenRepository {}
class MockToken extends Mock implements Token {}

void main() {
  group("Customer Repository Tests", () {
    late TokenRepository tokenRepository;
    late CustomerRepository customerRepository;
    late CustomerProvider mockCustomerProvider;
    late CustomerRepository customerRepositoryWithMock;

    setUp(() {
      registerFallbackValue(MockToken());
      tokenRepository = MockTokenRepository();
      when(() => tokenRepository.saveToken(token: any(named: "token"))).thenAnswer((_) async => null);
      customerRepository = CustomerRepository(customerProvider: CustomerProvider(), tokenRepository: tokenRepository);
      mockCustomerProvider = MockCustomerProvider();
      customerRepositoryWithMock = CustomerRepository(customerProvider: mockCustomerProvider, tokenRepository: tokenRepository);
    });

    test("Customer Repository can fetch customer", () async {
      var customer = await customerRepository.fetchCustomer();
      expect(customer, isA<Customer>());
    });

    test("Customer Repository throws error on fetch customer fail", () async {
      when(() => mockCustomerProvider.fetchCustomer())
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        customerRepositoryWithMock.fetchCustomer(),
        throwsA(isA<ApiException>())
      );
    });

    test("Customer Repository can update email", () async {
      var customer = await customerRepository.updateEmail(email: "email", customerId: "customerId");
      expect(customer, isA<Customer>());
    });

    test("Customer Repository throws error on update email fail", () async {
      when(() => mockCustomerProvider.updateEmail(body: any(named: "body"), customerId: any(named: "customerId")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        customerRepositoryWithMock.updateEmail(email: "email", customerId: "customerId"),
        throwsA(isA<ApiException>())
      );
    });

    test("Customer Repository can update password", () async {
      var customer = await customerRepository.updatePassword(oldPassword: "oldPassword", password: "password", passwordConfirmation: "passwordConfirmation", customerId: "customerId");
      expect(customer, isA<Customer>());
    });

    test("Customer Repository throws error on uupdate password fail", () async {
      when(() => mockCustomerProvider.updatePassword(body: any(named: "body"), customerId: any(named: "customerId")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));
      
      expect(
        customerRepositoryWithMock.updatePassword(oldPassword: "oldPassword", password: "password", passwordConfirmation: "passwordConfirmation", customerId: "customerId"),
        throwsA(isA<ApiException>())
      );
    });
  });
}