import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';

part 'password_form_event.dart';
part 'password_form_state.dart';

class PasswordFormBloc extends Bloc<PasswordFormEvent, PasswordFormState> {
  final CustomerRepository _customerRepository;
  final AuthenticationRepository _authenticationRepository;
  final CustomerBloc _customerBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300);
  
  PasswordFormBloc({required CustomerRepository customerRepository, required AuthenticationRepository authenticationRepository, required CustomerBloc customerBloc})
    : _customerRepository = customerRepository,
      _authenticationRepository = authenticationRepository,
      _customerBloc = customerBloc,
      super(PasswordFormState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<OldPasswordChanged>((event, emit) => _mapOldPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordConfirmationChanged>((event, emit) => _mapPasswordConfirmationChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<OldPasswordSubmitted>((event, emit) async => await _mapOldPasswordSubmittedToState(emit: emit));
    on<NewPasswordSubmitted>((event, emit) async => await _mapNewPasswordSubmittedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapOldPasswordChangedToState({required OldPasswordChanged event, required Emitter<PasswordFormState> emit}) {
    emit(state.update(oldPassword: event.oldPassword, isOldPasswordValid: Validators.isValidPassword(password: event.oldPassword)));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<PasswordFormState> emit}) {
    final bool isPasswordConfirmationValid = state.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: state.passwordConfirmation)
      : true;
    emit(state.update(password: event.password, isPasswordValid: Validators.isValidPassword(password:  event.password), isPasswordConfirmationValid: isPasswordConfirmationValid));
  }

  void _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event, required Emitter<PasswordFormState> emit}) {
    emit(state.update(passwordConfirmation: event.passwordConfirmation, isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: state.password, passwordConfirmation: event.passwordConfirmation)));
  }

  Future<void> _mapOldPasswordSubmittedToState({required Emitter<PasswordFormState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      bool isPasswordVerified = await _authenticationRepository.checkPassword(password: state.oldPassword);
      if (isPasswordVerified) {
        emit(state.update(isSubmitting: false, isOldPasswordVerified: true, isSuccessOldPassword: true));
      } else {
        emit(state.update(isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false, errorMessage: "Looks like that's the wrong password!"));
      }
    } on ApiException catch (exception) {
      emit(state.update(errorMessage: exception.error, isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false));
    }
  }

  Future<void> _mapNewPasswordSubmittedToState({required Emitter<PasswordFormState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      Customer customer = await _customerRepository.updatePassword(
        oldPassword: state.oldPassword,
        password: state.password, 
        passwordConfirmation: state.passwordConfirmation, 
        customerId: _customerBloc.customer!.identifier
      );
      emit(state.update(isSubmitting: false, isSuccess: true));
      _customerBloc.add(CustomerUpdated(customer: customer));
    } on ApiException catch (exception) {
      emit(state.update(errorMessage: exception.error, isSubmitting: false));
    }
  }

  void _mapResetToState({required Emitter<PasswordFormState> emit}) {
    emit(state.update(isSuccess: false, isSuccessOldPassword: false, errorMessage: ""));
  }
}
