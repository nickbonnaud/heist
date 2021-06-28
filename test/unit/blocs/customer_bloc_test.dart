import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Customer Bloc Tests", () {
    late CustomerRepository customerRepository;
    late CustomerBloc customerBloc;

    late CustomerState _baseState;
    late Customer _customer;

    setUp(() {
      customerRepository = MockCustomerRepository();
      customerBloc = CustomerBloc(customerRepository: customerRepository);
      _baseState = customerBloc.state;
    });

    tearDown(() {
      customerBloc.close();
    });

    test("Initial state of CustomerBloc is CustomerState.initial()", () {
      expect(customerBloc.state, CustomerState.initial());
    });

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc has customer getter",
      build: () => customerBloc,
      seed: () => customerBloc.state.update(customer: MockCustomer()),
      verify: (_) {
        expect(customerBloc.customer, isA<Customer>());
      }
    );

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc CustomerAuthenticated event yields state: [loading: true], [loading: false, customer: customer]",
      build: () => customerBloc,
      act: (bloc) {
        _customer = MockCustomer();
        when(() => customerRepository.fetchCustomer()).thenAnswer((_) async => _customer);
        bloc.add(CustomerAuthenticated());
      },
      expect: () {
        CustomerState firstState = _baseState.update(loading: true);
        CustomerState secondState = firstState.update(loading: false, customer: _customer);
        return [firstState, secondState];
      }
    );

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc CustomerAuthenticated event calls customerRepository.fetchCustomer",
      build: () => customerBloc,
      act: (bloc) {
        _customer = MockCustomer();
        when(() => customerRepository.fetchCustomer()).thenAnswer((_) async => _customer);
        bloc.add(CustomerAuthenticated());
      },
      verify: (_) {
        verify(() => customerRepository.fetchCustomer()).called(1);
      }
    );

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc CustomerAuthenticated event on error yields state: [loading: true], [loading: false, errorMessage: error]",
      build: () => customerBloc,
      act: (bloc) {
        when(() => customerRepository.fetchCustomer()).thenThrow(ApiException(error: "error"));
        bloc.add(CustomerAuthenticated());
      },
      expect: () {
        CustomerState firstState = _baseState.update(loading: true);
        CustomerState secondState = firstState.update(loading: false, errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc CustomerLoggedIn event yields state: [customer: customer, loading: false, errorMessage: '']",
      build: () => customerBloc,
      act: (bloc) {
        _customer = MockCustomer();
        bloc.add(CustomerLoggedIn(customer: _customer));
      },
      expect: () {
        return [_baseState.update(customer: _customer, loading: false, errorMessage: "")];
      }
    );

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc CustomerLoggedOut event yields state: [customer: null, loading: false, errorMessage: '']",
      build: () => customerBloc,
      act: (bloc) {
        bloc.add(CustomerLoggedOut());
      },
      expect: () {
        return [_baseState.update(customer: null, loading: false, errorMessage: "")];
      }
    );

    blocTest<CustomerBloc, CustomerState>(
      "Customer Bloc CustomerUpdated event yields state: [customer: customer]",
      build: () => customerBloc,
      seed: () {
        _customer = MockCustomer();
        _baseState = _baseState.update(customer: _customer);
        return _baseState;
      },
      act: (bloc) {
        _customer = MockCustomer();
        bloc.add(CustomerUpdated(customer: _customer));
      },
      expect: () {
        return [_baseState.update(customer: _customer)];
      }
    );
  });
}