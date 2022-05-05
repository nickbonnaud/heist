import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/auth_screen/widgets/forms/widgets/login/widgets/login_form/bloc/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Login Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;

    late LoginBloc loginBloc;

    late LoginState _baseState;

    late String email;
    late String password;

    setUp(() {
      registerFallbackValue(LoggedIn(customer: MockCustomer()));

      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
        .thenAnswer((_) async => MockCustomer());
      
      authenticationBloc = MockAuthenticationBloc();
      when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
        .thenReturn(null);

      loginBloc = LoginBloc(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc);
      _baseState = loginBloc.state;
    });

    tearDown(() {
      loginBloc.close();
    });

    test("Initial state of LoginBloc is LoginState.empty()", () {
      expect(loginBloc.state, LoginState.empty());
    });

    blocTest<LoginBloc, LoginState>(
      "LoginBloc EmailChanged event yields state: [isEmailValid: bool]",
      build: () => loginBloc,
      act: (bloc) {
        email = faker.internet.email();
        bloc.add(EmailChanged(email: email));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(email: email, isEmailValid: true)]
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc PasswordChanged event yields state: [isPasswordValid: bool]",
      build: () => loginBloc,
      act: (bloc) {
        password = "kdkGDDKddj^hdhdg338dhh!!!hshs<ccHHH";
        bloc.add(const PasswordChanged(password: "kdkGDDKddj^hdhdg338dhh!!!hshs<ccHHH"));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [_baseState.update(password: password, isPasswordValid: true)]
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc Submitted event yields state: [LoginState.loading()], [LoginState.success()]",
      build: () => loginBloc,
      seed: () {
        email = faker.internet.email();
        password = "kdkGDDKddj^hdhdg338dhh!!!hshs<ccHHH";

        _baseState = _baseState.update(email: email, password: password);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc Submitted event calls authenticationRepository.login",
      build: () => loginBloc,
      seed: () {
        email = faker.internet.email();
        password = "kdkGDDKddj^hdhdg338dhh!!!hshs<ccHHH";

        _baseState = _baseState.update(email: email, password: password);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      verify: (_) {
        verify(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password"))).called(1); 
      } 
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc Submitted event on failure yields state: [LoginState.loading()], [LoginState.failure()]",
      build: () {
        when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
          .thenThrow(const ApiException(error: "error"));
        return loginBloc;
      },
      seed: () {
        email = faker.internet.email();
        password = "kdkGDDKddj^hdhdg338dhh!!!hshs<ccHHH";

        _baseState = _baseState.update(email: email, password: password);
        return _baseState;
      },
      act: (bloc) => bloc.add(Submitted()),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: 'error')]
    );
  });
}