import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/auth_screen/widgets/forms/widgets/login/widgets/login_form/bloc/login_bloc.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockCustomer extends Mock implements Customer {}

void main() {
  group("Login Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;

    late LoginBloc loginBloc;

    late LoginState _baseState;

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
      act: (bloc) => bloc.add(EmailChanged(email: faker.internet.email())),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isEmailValid: true)]
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc PasswordChanged event yields state: [isPasswordValid: bool]",
      build: () => loginBloc,
      act: (bloc) => bloc.add(PasswordChanged(password: "kdkGDDKddj^hdhdg338dhh!!!hshs<ccHHH")),
      wait: Duration(milliseconds: 300),
      expect: () => [_baseState.update(isPasswordValid: true)]
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc Submitted event yields state: [LoginState.loading()], [LoginState.success()]",
      build: () => loginBloc,
      act: (bloc) => bloc.add(Submitted(email: "email", password: "password")),
      expect: () => [LoginState.loading(), LoginState.success()]
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc Submitted event calls authenticationRepository.login",
      build: () => loginBloc,
      act: (bloc) => bloc.add(Submitted(email: "email", password: "password")),
      verify: (_) {
        verify(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password"))).called(1); 
      } 
    );

    blocTest<LoginBloc, LoginState>(
      "LoginBloc Submitted event on failure yields state: [LoginState.loading()], [LoginState.failure()]",
      build: () {
        when(() => authenticationRepository.login(email: any(named: "email"), password: any(named: "password")))
          .thenThrow(ApiException(error: "error"));
        return loginBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: "email", password: "password")),
      expect: () => [LoginState.loading(), LoginState.failure(errorMessage: "error")]
    );
  });
}