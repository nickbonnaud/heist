import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/request_reset_password_screen/bloc/request_reset_form_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group("Request Reset Form Bloc Tests", () {
    late AuthenticationRepository authenticationRepository;
    late RequestResetFormBloc requestResetFormBloc;

    late RequestResetFormState _baseState;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      requestResetFormBloc = RequestResetFormBloc(authenticationRepository: authenticationRepository);
      _baseState = requestResetFormBloc.state;
    });

    tearDown(() {
      requestResetFormBloc.close();
    });

    test("Initial state of RequestResetFormBloc is RequestResetFormState.initial()", () {
      expect(requestResetFormBloc.state, RequestResetFormState.initial());
    });

    blocTest<RequestResetFormBloc, RequestResetFormState>(
      "RequestResetFormBloc EmailChanged event yields state: [isEmailValid: true]",
      build: () => requestResetFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(EmailChanged(email: faker.internet.freeEmail())),
      expect: () => [_baseState.update(isEmailValid: true)]
    );

    blocTest<RequestResetFormBloc, RequestResetFormState>(
      "RequestResetFormBloc Submitted event yields state: [isSubmitting: true], [isSubmitting: false, isSuccess: true]",
      build: () {
        when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
          .thenAnswer((_) async => true);
        
        return requestResetFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.freeEmail())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true)]
    );

    blocTest<RequestResetFormBloc, RequestResetFormState>(
      "RequestResetFormBloc Submitted event on fail yields state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () {
        when(() => authenticationRepository.requestPasswordReset(email: any(named: "email")))
          .thenThrow(const ApiException(error: "error"));
        
        return requestResetFormBloc;
      },
      act: (bloc) => bloc.add(Submitted(email: faker.internet.freeEmail())),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<RequestResetFormBloc, RequestResetFormState>(
      "RequestResetFormBloc Reset event yields state: [errorMessage: "", isSuccess: false]",
      build: () => requestResetFormBloc,
      seed: () => _baseState.update(errorMessage: "error", isSuccess: true),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "")]
    );
  });
}