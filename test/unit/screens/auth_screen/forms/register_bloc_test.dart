import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/auth_screen/widgets/forms/widgets/register/widgets/register_form/bloc/register_bloc.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Register Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;

    late RegisterBloc registerBloc;

    late RegisterState _baseState;

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
      act: (bloc) => bloc.add(EmailChanged(email: faker.internet.email())),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isEmailValid: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc PasswordChanged event yields state: [isPasswordValid: true]",
      build: () => registerBloc,
      act: (bloc) => bloc.add(PasswordChanged(password: "hdhFDSg3558154#@%&cfbcfgDG", passwordConfirmation: "hdhFDSg3558154#@%&cfbcfgDG")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isPasswordValid: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc PasswordConfirmationChanged event yields state: [isPasswordConfirmationValid: true]",
      build: () => registerBloc,
      act: (bloc) => bloc.add(PasswordConfirmationChanged(passwordConfirmation: "hdhFDSg3558154#@%&cfbcfgDG", password: "hdhFDSg3558154#@%&cfbcfgDG")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isPasswordConfirmationValid: true)]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc Submitted event yields state: [RegisterState.loading()], [RegisterState.success()]",
      build: () => registerBloc,
      act: (bloc) => bloc.add(Submitted(email: faker.internet.email(), password: "hdhFDSg3558154#@%&cfbcfgDG", passwordConfirmation: "hdhFDSg3558154#@%&cfbcfgDG")),
      expect: () => [RegisterState.loading(), RegisterState.success()]
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc Submitted event calls authenticationRepository.register",
      build: () => registerBloc,
      act: (bloc) => bloc.add(Submitted(email: faker.internet.email(), password: "hdhFDSg3558154#@%&cfbcfgDG", passwordConfirmation: "hdhFDSg3558154#@%&cfbcfgDG")),
      verify: (_) {
        verify(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")));
      }
    );

    blocTest<RegisterBloc, RegisterState>(
      "RegisterBloc Submitted event on fail yields state: [RegisterState.loading(), RegisterState.failure()]",
      build: () {
        when(() => authenticationRepository.register(email: any(named: "email"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenThrow(ApiException(error: "error"));
        return registerBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.email(), password: "hdhFDSg3558154#@%&cfbcfgDG", passwordConfirmation: "hdhFDSg3558154#@%&cfbcfgDG")),
      expect: () => [RegisterState.loading(), RegisterState.failure(errorMessage: "error")]
    );
  });
}