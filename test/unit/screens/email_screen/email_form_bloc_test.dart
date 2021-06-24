import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/email_screen/bloc/email_form_bloc.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Email Form Bloc Tests", () {
    late CustomerRepository customerRepository;
    late CustomerBloc customerBloc;

    late EmailFormBloc emailFormBloc;

    late EmailFormState _baseState;

    setUp(() {
      customerRepository = MockCustomerRepository();
      customerBloc = MockCustomerBloc();

      emailFormBloc = EmailFormBloc(customerRepository: customerRepository, customerBloc: customerBloc);
      _baseState = emailFormBloc.state;
    });

    tearDown(() {
      emailFormBloc.close();
    });

    test("Initial state of EmailFormBloc is EmailFormState.initial()", () {
      expect(emailFormBloc.state, EmailFormState.initial());
    });

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc EmailChanged event yields state: [isEmailValid: true]",
      build: () => emailFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(EmailChanged(email: faker.internet.freeEmail())),
      expect: () => [_baseState.update(isEmailValid: true)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () {
        when(() => customerRepository.updateEmail(email: any(named: "email"), customerId: any(named: "customerId")))
          .thenAnswer((_) async => MockCustomer());
        return emailFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.email(), identifier: faker.guid.guid())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () {
        when(() => customerRepository.updateEmail(email: any(named: "email"), customerId: any(named: "customerId")))
          .thenThrow(ApiException(error: "error"));
        return emailFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.email(), identifier: faker.guid.guid())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<EmailFormBloc, EmailFormState>(
      "EmailFormBloc Reset event yields state: [errorMessage: '', isSuccess: false]",
      build: () => emailFormBloc,
      seed: () => _baseState.update(errorMessage: "error", isSuccess: true),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(errorMessage: "", isSuccess: false)]
    );
  });
}