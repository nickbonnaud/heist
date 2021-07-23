import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'password_form_event.dart';
part 'password_form_state.dart';

class PasswordFormBloc extends Bloc<PasswordFormEvent, PasswordFormState> {
  final CustomerRepository _customerRepository;
  final AuthenticationRepository _authenticationRepository;
  final CustomerBloc _customerBloc;
  
  PasswordFormBloc({required CustomerRepository customerRepository, required AuthenticationRepository authenticationRepository, required CustomerBloc customerBloc})
    : _customerRepository = customerRepository,
      _authenticationRepository = authenticationRepository,
      _customerBloc = customerBloc,
      super(PasswordFormState.initial());

  @override
  Stream<Transition<PasswordFormEvent, PasswordFormState>> transformEvents(Stream<PasswordFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !OldPasswordChanged && event is !PasswordChanged && event is !PasswordConfirmationChanged);
    final debounceStream = events.where((event) => event is OldPasswordChanged || event is PasswordChanged || event is PasswordConfirmationChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<PasswordFormState> mapEventToState(PasswordFormEvent event) async* {
    if (event is OldPasswordChanged) {
      yield* _mapOldPasswordChanged(event);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChanged(event);
    } else if (event is PasswordConfirmationChanged) {
      yield* _mapPasswordConfirmationChangedToState(event);
    } else if (event is OldPasswordSubmitted) {
      yield* _mapOldPasswordSubmitted(event);
    } else if (event is NewPasswordSubmitted) {
      yield* _mapNewPasswordSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<PasswordFormState> _mapOldPasswordChanged(OldPasswordChanged event) async* {
    yield state.update(isOldPasswordValid: Validators.isValidPassword(password: event.oldPassword));
  }

  Stream<PasswordFormState> _mapPasswordChanged(PasswordChanged event) async* {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(password:  event.password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<PasswordFormState> _mapPasswordConfirmationChangedToState(PasswordConfirmationChanged event) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: event.passwordConfirmation));
  }

  Stream<PasswordFormState> _mapOldPasswordSubmitted(OldPasswordSubmitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      bool isPasswordVerified = await _authenticationRepository.checkPassword(password: event.oldPassword);
      if (isPasswordVerified) {
        yield state.update(isSubmitting: false, isOldPasswordVerified: true, isSuccessOldPassword: true);
      } else {
        yield state.update(isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false, errorMessage: "Looks like that's the wrong password!");
      }
    } on ApiException catch (exception) {
      yield state.update(errorMessage: exception.error, isSubmitting: false, isOldPasswordVerified: false, isSuccessOldPassword: false);
    }
  }

  Stream<PasswordFormState> _mapNewPasswordSubmittedToState(NewPasswordSubmitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _customerRepository.updatePassword(
        oldPassword: event.oldPassword,
        password: event.password, 
        passwordConfirmation: event.passwordConfirmation, 
        customerId: event.customerIdentifier
      );
      yield state.update(isSubmitting: false, isSuccess: true);
      _customerBloc.add(CustomerUpdated(customer: customer));
    } on ApiException catch (exception) {
      yield state.update(errorMessage: exception.error, isSubmitting: false);
    }
  }

  Stream<PasswordFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isSuccessOldPassword: false, errorMessage: "");
  }
}
