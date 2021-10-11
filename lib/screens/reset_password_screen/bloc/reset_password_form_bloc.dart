import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';

part 'reset_password_form_event.dart';
part 'reset_password_form_state.dart';

class ResetPasswordFormBloc extends Bloc<ResetPasswordFormEvent, ResetPasswordFormState> {
  final AuthenticationRepository _authenticationRepository;

  final Duration _debounceTime = Duration(milliseconds: 300);
  
  ResetPasswordFormBloc({required AuthenticationRepository authenticationRepository, required String email})
    : _authenticationRepository = authenticationRepository,
      super(ResetPasswordFormState.initial(email: email)) { _eventHandler(); }

  void _eventHandler() {
    on<ResetCodeChanged>((event, emit) => _mapResetCodeChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordConfirmationChanged>((event, emit) => _mapPasswordConfirmationChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapResetCodeChangedToState({required ResetCodeChanged event, required Emitter<ResetPasswordFormState> emit}) {
    emit(state.update(isResetCodeValid: Validators.isValidResetCode(resetCode: event.resetCode)));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<ResetPasswordFormState> emit}) {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : false;
    emit(state.update(isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid));
  }

  void _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event, required Emitter<ResetPasswordFormState> emit}) {
    emit(state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<ResetPasswordFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      await _authenticationRepository.resetPassword(email: state.email, resetCode: event.resetCode, password: event.password, passwordConfirmation: event.passwordConfirmation);
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<ResetPasswordFormState> emit}) {
    emit(state.update(errorMessage: "", isSubmitting: false, isSuccess: false));
  }
}
