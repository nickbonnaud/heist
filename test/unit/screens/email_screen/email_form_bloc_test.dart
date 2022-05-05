import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/email_screen/bloc/email_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Email Form Bloc Tests", () {
    late CustomerRepository customerRepository;
    late CustomerBloc customerBloc;

    late EmailFormBloc emailFormBloc;

    late EmailFormState _baseState;

    late Customer customer;
    late String email;

    setUp(() {
      customerRepository = MockCustomerRepository();
      customerBloc = MockCustomerBloc();

      customer = MockDataGenerator().createCustomer();
      when(() => customerBloc.customer).thenReturn(customer);

      emailFormBloc = EmailFormBloc(customerRepository: customerRepository, customerBloc: customerBloc);
      _baseState = emailFormBloc.state;
    });

    tearDown(() {
      emailFormBloc.close();
    });

    test("Initial state of EmailFormBloc is EmailFormState.initial()", () {
      expect(emailFormBloc.state, EmailFormState.initial(email: customer.email));
    });

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc EmailChanged event yields state: [isEmailValid: true]",
      build: () => emailFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        email = faker.internet.freeEmail();
        bloc.add(EmailChanged(email: email));
      },
      expect: () => [_baseState.update(email: email, isEmailValid: true)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () {
        when(() => customerRepository.updateEmail(email: any(named: "email"), customerId: any(named: "customerId")))
          .thenAnswer((_) async => MockCustomer());
        return emailFormBloc;
      },
      seed: () {
        email = faker.internet.freeEmail();
        _baseState = _baseState.update(email: email);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () {
        when(() => customerRepository.updateEmail(email: any(named: "email"), customerId: any(named: "customerId")))
          .thenThrow(const ApiException(error: "error"));
        return emailFormBloc;
      },
      seed: () {
        email = faker.internet.freeEmail();
        _baseState = _baseState.update(email: email);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc Reset event yields state: [errorMessage: '', isSuccess: false]",
      build: () => emailFormBloc,
      seed: () {
        email = faker.internet.email();
        _baseState = _baseState.update(email: email, errorMessage: "error", isSuccess: true);
        return _baseState;
      },
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(errorMessage: "", isSuccess: false)]
    );
  });
}