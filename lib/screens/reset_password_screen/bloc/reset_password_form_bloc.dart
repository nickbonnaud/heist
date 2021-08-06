import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'reset_password_form_event.dart';
part 'reset_password_form_state.dart';

class ResetPasswordFormBloc extends Bloc<ResetPasswordFormEvent, ResetPasswordFormState> {
  final AuthenticationRepository _authenticationRepository;
  
  ResetPasswordFormBloc({required AuthenticationRepository authenticationRepository, required String email})
    : _authenticationRepository = authenticationRepository,
      super(ResetPasswordFormState.initial(email: email));

  @override
  Stream<Transition<ResetPasswordFormEvent, ResetPasswordFormState>> transformEvents(Stream<ResetPasswordFormEvent> events, TransitionFunction<ResetPasswordFormEvent, ResetPasswordFormState> transitionFn) {
    final nonDebounceStream = events.where((event) => event is !ResetCodeChanged && event is !PasswordChanged && event is !PasswordConfirmationChanged);
    final debounceStream = events.where((event) => event is ResetCodeChanged || event is PasswordChanged || event is PasswordConfirmationChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<ResetPasswordFormState> mapEventToState(ResetPasswordFormEvent event) async* {
    if (event is ResetCodeChanged) {
      yield* _mapResetCodeChangedToState(event: event);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event: event);
    } else if (event is PasswordConfirmationChanged) {
      yield* _mapPasswordConfirmationChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<ResetPasswordFormState> _mapResetCodeChangedToState({required ResetCodeChanged event}) async* {
    yield state.update(isResetCodeValid: Validators.isValidResetCode(resetCode: event.resetCode));
  }

  Stream<ResetPasswordFormState> _mapPasswordChangedToState({required PasswordChanged event}) async* {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : false;
    yield state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<ResetPasswordFormState> _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event}) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation));
  }

  Stream<ResetPasswordFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      await _authenticationRepository.resetPassword(email: state.email, resetCode: event.resetCode, password: event.password, passwordConfirmation: event.passwordConfirmation);
      yield state.update(isSubmitting: false, isSuccess: true);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<ResetPasswordFormState> _mapResetToState() async* {
    yield state.update(errorMessage: "", isSubmitting: false, isSuccess: false);
  }
}
