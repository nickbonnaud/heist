import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/password_screen/bloc/password_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Password Form Bloc Tests", () {
    late CustomerRepository customerRepository;
    late AuthenticationRepository authenticationRepository;
    late CustomerBloc customerBloc;

    late PasswordFormBloc passwordFormBloc;
    late PasswordFormState _baseState;

    late Customer customer;

    late String oldPassword;
    late String password;
    late String passwordConfirmation;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      customerRepository = MockCustomerRepository();
      authenticationRepository = MockAuthenticationRepository();

      customer = MockDataGenerator().createCustomer();
      customerBloc = MockCustomerBloc();
      when(() => customerBloc.customer).thenReturn(customer);

      passwordFormBloc = PasswordFormBloc(customerRepository: customerRepository, authenticationRepository: authenticationRepository, customerBloc: customerBloc);
      _baseState = passwordFormBloc.state;
    });

    tearDown(() {
      passwordFormBloc.close();
    });

    test("Initial state of PasswordFormBloc is PasswordFormState.initial()", () {
      expect(passwordFormBloc.state, PasswordFormState.initial());
    });

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc OldPasswordChanged event yields state: [isOldPasswordValid: true]",
      build: () => passwordFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        oldPassword = "fdbhGHShh@&7342wmcxs523&^";
        bloc.add(OldPasswordChanged(oldPassword: oldPassword));
      },
      expect: () => [_baseState.update(oldPassword: oldPassword, isOldPasswordValid: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc PasswordChanged event yields state: [isPasswordValid: true]",
      build: () => passwordFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) {
        password = "ncvdhBDSJSjh76353!!!@#";
        bloc.add(PasswordChanged(password: password));
      },
      expect: () => [_baseState.update(password: password, isPasswordValid: true, isPasswordConfirmationValid: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc PasswordConfirmationChanged event yields state: [isPasswordConfirmationValid: true]",
      build: () => passwordFormBloc,
      wait: const Duration(milliseconds: 300),
      seed: () {
        password = "ncvdhBDSJSjh76353!!!@#";
        _baseState = _baseState.update(password: password);
        return _baseState;
      },
      act: (bloc) {
        passwordConfirmation = password;
        bloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
      },
      expect: () => [_baseState.update(passwordConfirmation: passwordConfirmation, isPasswordConfirmationValid: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc OldPasswordSubmitted event on password match yields state: [isSubmitting: true], [isSubmitting: false, isOldPasswordVerified: true, isSuccessOldPassword: true]",
      build: () => passwordFormBloc,
      seed: () {
        oldPassword = "cnjsabj6363d%%&&*ncBDDG";
        _baseState = _baseState.update(oldPassword: oldPassword);
        return _baseState;
      },
      act: (bloc) {
        when(() => authenticationRepository.checkPassword(password: any(named: "password")))
          .thenAnswer((_) async => true);
        
        bloc.add(OldPasswordSubmitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isOldPasswordVerified: true, isSuccessOldPassword: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc OldPasswordSubmitted event calls authenticationRepository.checkPassword",
      build: () => passwordFormBloc,
      seed: () {
        oldPassword = "cnjsabj6363d%%&&*ncBDDG";
        _baseState = _baseState.update(oldPassword: oldPassword);
        return _baseState;
      },
      act: (bloc) {
        when(() => authenticationRepository.checkPassword(password: any(named: "password")))
          .thenAnswer((_) async => true);
        
        bloc.add(OldPasswordSubmitted());
      },
      verify: (_) {
        verify(() => authenticationRepository.checkPassword(password: any(named: "password"))).called(1);
      }
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc OldPasswordSubmitted event on password not matching yields state: [isSubmitting: true], [isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false, errorMessage: Looks like that's the wrong password!]",
      build: () => passwordFormBloc,
      seed: () {
        oldPassword = "cnjsabj6363d%%&&*ncBDDG";
        _baseState = _baseState.update(oldPassword: oldPassword);
        return _baseState;
      },
      act: (bloc) {
        when(() => authenticationRepository.checkPassword(password: any(named: "password")))
          .thenAnswer((_) async => false);
        
        bloc.add(OldPasswordSubmitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false, errorMessage: "Looks like that's the wrong password!")]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc OldPasswordSubmitted event on fail yields state: [isSubmitting: true], [errorMessage: error, isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false]",
      build: () => passwordFormBloc,
      seed: () {
        oldPassword = "cnjsabj6363d%%&&*ncBDDG";
        _baseState = _baseState.update(oldPassword: oldPassword);
        return _baseState;
      },
      act: (bloc) {
        when(() => authenticationRepository.checkPassword(password: any(named: "password")))
          .thenThrow(const ApiException(error: "error"));
        
        bloc.add(OldPasswordSubmitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(errorMessage: "error", isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc NewPasswordSubmitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => passwordFormBloc,
      seed: () {
        password = "cnjsabj6363d%%&&*ncBDDG";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) {
        when(() => customerRepository.updatePassword(oldPassword: any(named: "oldPassword"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), customerId: any(named: "customerId")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);
        
        bloc.add(NewPasswordSubmitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc NewPasswordSubmitted event calls customerRepository.updatePassword && customerBloc.add",
      build: () => passwordFormBloc,
      seed: () {
        password = "cnjsabj6363d%%&&*ncBDDG";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) {
        when(() => customerRepository.updatePassword(oldPassword: any(named: "oldPassword"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), customerId: any(named: "customerId")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);
        
        bloc.add(NewPasswordSubmitted());
      },
      verify: (_) {
        verify(() => customerRepository.updatePassword(oldPassword: any(named: "oldPassword"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), customerId: any(named: "customerId"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc NewPasswordSubmitted event on fail yields state: [isSubmitting: true], [errorMessage: exception.error, isSubmitting: false]",
      build: () => passwordFormBloc,
      seed: () {
        password = "cnjsabj6363d%%&&*ncBDDG";
        passwordConfirmation = password;
        _baseState = _baseState.update(password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) {
        when(() => customerRepository.updatePassword(oldPassword: any(named: "oldPassword"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation"), customerId: any(named: "customerId")))
          .thenThrow(const ApiException(error: "error"));
        
        bloc.add(NewPasswordSubmitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<PasswordFormBloc, PasswordFormState>(
      "PasswordFormBloc Reset event yields state: [isSuccess: false, isSuccessOldPassword: false, errorMessage: ""]",
      build: () => passwordFormBloc,
      seed: () {
        oldPassword = "cnjsabj6363d%%&&*ncBDDG";
        password = "ncvdhBDSJSjh76353!!!@#";
        passwordConfirmation = password;
        _baseState = _baseState.update(oldPassword: oldPassword, password: password, passwordConfirmation: passwordConfirmation, isSuccess: true, isSuccessOldPassword: true, errorMessage: "error");
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, isSuccessOldPassword: false, errorMessage: "")]
    );
  });
}