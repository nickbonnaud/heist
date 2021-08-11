import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/sign_out_screen/bloc/sign_out_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  group("Sign Out Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    late SignOutBloc signOutBloc;

    late SignOutState _baseState;

    setUp(() {
      registerFallbackValue(LoggedOut());

      authenticationRepository = MockAuthenticationRepository();

      authenticationBloc = MockAuthenticationBloc();
      when(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>())))
        .thenReturn(null);

      signOutBloc = SignOutBloc(authenticationRepository: authenticationRepository, authenticationBloc: authenticationBloc);
      _baseState = signOutBloc.state;
    });

    tearDown(() {
      signOutBloc.close();
    });

    test("Initial state of SignOutBloc is SignOutState.initial()", () {
      expect(signOutBloc.state, SignOutState.initial());
    });

    blocTest<SignOutBloc, SignOutState>(
      "SignOutBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () => signOutBloc,
      act: (bloc) {
        when(() => authenticationRepository.logout())
          .thenAnswer((_) async => true);
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<SignOutBloc, SignOutState>(
      "SignOutBloc Submitted event on repository error yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () => signOutBloc,
      act: (bloc) {
        when(() => authenticationRepository.logout())
          .thenThrow(ApiException(error: "error"));
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: 'error')]
    );

    blocTest<SignOutBloc, SignOutState>(
      "SignOutBloc Submitted event on unable to sign out yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: An error occurred. Please try again.]",
      build: () => signOutBloc,
      act: (bloc) {
        when(() => authenticationRepository.logout())
          .thenAnswer((_) async => false);
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: 'An error occurred. Please try again.')]
    );

    blocTest<SignOutBloc, SignOutState>(
      "SignOutBloc Submitted event calls authenticationRepository.logout and authenticationBloc.add",
      build: () => signOutBloc,
      act: (bloc) {
        when(() => authenticationRepository.logout())
          .thenAnswer((_) async => true);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => authenticationRepository.logout()).called(1);
        verify(() => authenticationBloc.add(any(that: isA<AuthenticationEvent>()))).called(1);
      }
    );

    blocTest<SignOutBloc, SignOutState>(
      "SignOutBloc Reset event yields state: [isSuccess: false, errorMessage: '']",
      build: () => signOutBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error"),
      act: (bloc) {
        bloc.add(Reset());
      },
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}