import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/auth_screen/widgets/forms/widgets/register/widgets/register_form/bloc/register_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Register Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;

    late RegisterBloc registerBloc;

    late RegisterState _baseState;

    late String email;
    late String password;
    late String passwordConfirmation;

    setUp(() {
      registerFallbackValue(LoggedIn(customer: MockCustomer()));

      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
        .thenAnswer((_) async => MockCustomer());

      authenticationBloc = MockAuthenticationBloc();
      when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
        .thenReturn(null);

      registerBloc = RegisterBloc(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc);
      _baseState = registerBloc.state;
    });

    tearDown(() {
      registerBloc.close();
    });

    test("Initial state of registerBloc is RegisterState.empty()", () {
      expect(registerBloc.state, RegisterState.empty());
    });

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc EmailChanged event yields state: [isEmailValid: true]",
      build: () => registerBloc,
      act: (bloc) {
        email = faker.internet.email();
        bloc.add(EmailChanged(email: email));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(email: email, isEmailValid: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc PasswordChanged event yields state: [isPasswordValid: true]",
      build: () => registerBloc,
      act: (bloc) {
        password = "hdhFDSg3558154#@%&cfbcfgDG";
        bloc.add(PasswordChanged(password: password));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(password: password, isPasswordValid: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc PasswordConfirmationChanged event yields state: [isPasswordConfirmationValid: true]",
      build: () => registerBloc,
      seed: () {
        password = "hdhFDSg3558154#@%&cfbcfgDG";
        _baseState = _baseState.update(password: password);
        return _baseState;
      },
      act: (bloc) {
        passwordConfirmation = password;
        bloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(passwordConfirmation: passwordConfirmation, isPasswordConfirmationValid: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc Submitted event yields state: [RegisterState.loading()], [RegisterState.success()]",
      build: () => registerBloc,
      seed: () {
        email = faker.internet.email();
        password = "hdhFDSg3558154#@%&cfbcfgDG";
        passwordConfirmation = password;

        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc Submitted event calls authenticationRepository.register",
      build: () => registerBloc,
      seed: () {
        email = faker.internet.email();
        password = "hdhFDSg3558154#@%&cfbcfgDG";
        passwordConfirmation = password;

        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      verify: (_) {
        verify(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")));
      }
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc Submitted event on fail yields state: [RegisterState.loading(), RegisterState.failure()]",
      build: () {
        when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenThrow(const ApiException(error: "error"));
        return registerBloc;
      },
      seed: () {
        email = faker.internet.email();
        password = "hdhFDSg3558154#@%&cfbcfgDG";
        passwordConfirmation = password;

        _baseState = _baseState.update(email: email, password: password, passwordConfirmation: passwordConfirmation);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );
  });
}