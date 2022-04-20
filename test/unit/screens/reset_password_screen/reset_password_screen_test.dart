import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/reset_password_screen/bloc/reset_password_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group("Reset Password Form Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late ResetPasswordFormBloc resetPasswordFormBloc;

    late String _email;
    late ResetPasswordFormState _baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      _email = faker.internet.freeEmail();
      resetPasswordFormBloc = ResetPasswordFormBloc(authenticationRepository: authenticationRepository, email: _email);
      _baseState = resetPasswordFormBloc.state;
    });

    tearDown(() {
      resetPasswordFormBloc.close();
    });

    test("Initial state of ResetPasswordFormBloc is ResetPasswordFormBloc.initial()", () {
      expect(resetPasswordFormBloc.state, ResetPasswordFormState.initial(email: _email));
    });

    blocTest<ResetPasswordFormBloc, ResetPasswordFormState>(
      "ResetPasswordFormBloc ResetCodeChanged event yields state: [isResetCodeValid: false]",
      build: () => resetPasswordFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const ResetCodeChanged(resetCode: "3#dj")),
      expect: () => [_baseState.update(isResetCodeValid: false)]
    );

    blocTest<ResetPasswordFormBloc, ResetPasswordFormState>(
      "ResetPasswordFormBloc PasswordChanged event yields state: [isPasswordValid: true]",
      build: () => resetPasswordFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const PasswordChanged(password: "cdndjHCDhbs!!#3474", passwordConfirmation: "")),
      expect: () => [_baseState.update(isPasswordValid: true)]
    );

    blocTest<ResetPasswordFormBloc, ResetPasswordFormState>(
      "ResetPasswordFormBloc PasswordConfirmationChanged event yields state: [isPasswordConfirmationValid: false]",
      build: () => resetPasswordFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const PasswordConfirmationChanged(password: "jSg@nd556&sj", passwordConfirmation: "password")),
      expect: () => [_baseState.update(isPasswordConfirmationValid: false)]
    );

    blocTest<ResetPasswordFormBloc, ResetPasswordFormState>(
      "ResetPasswordFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () {
        when(() => authenticationRepository.resetPassword(email: any(named: "email"), resetCode: any(named: "resetCode"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenAnswer((_) async => true);

        return resetPasswordFormBloc;
      },
      act: (bloc) => bloc.add(const Submitted(resetCode: "resetCode", password: 'password', passwordConfirmation: 'passwordConfirmation')),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<ResetPasswordFormBloc, ResetPasswordFormState>(
      "ResetPasswordFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () {
        when(() => authenticationRepository.resetPassword(email: any(named: "email"), resetCode: any(named: "resetCode"), password: any(named: "password"), passwordConfirmation: any(named: "passwordConfirmation")))
          .thenThrow(const ApiException(error: "error"));

        return resetPasswordFormBloc;
      },
      act: (bloc) => bloc.add(const Submitted(resetCode: "resetCode", password: 'password', passwordConfirmation: 'passwordConfirmation')),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<ResetPasswordFormBloc, ResetPasswordFormState>(
      "ResetPasswordFormBloc Reset event yields state: [errorMessage: '', isSuccess: false]",
      build: () => resetPasswordFormBloc,
      seed: () => _baseState.update(errorMessage: "error", isSuccess: true),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(errorMessage: "", isSuccess: false)]
    );
  });
}