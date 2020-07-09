import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'password_form_event.dart';
part 'password_form_state.dart';

class PasswordFormBloc extends Bloc<PasswordFormEvent, PasswordFormState> {
  final CustomerRepository _customerRepository;
  final AuthenticationBloc _authenticationBloc;
  
  PasswordFormBloc({@required CustomerRepository customerRepository, @required AuthenticationBloc authenticationBloc})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      _authenticationBloc = authenticationBloc,
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
    yield state.update(isOldPasswordValid: Validators.isValidPassword(event.oldPassword));
  }

  Stream<PasswordFormState> _mapPasswordChanged(PasswordChanged event) async* {
    final bool isPasswordConfirmationValid = event.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(event.password, event.passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(event.password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<PasswordFormState> _mapPasswordConfirmationChangedToState(PasswordConfirmationChanged event) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(event.password, event.passwordConfirmation));
  }

  Stream<PasswordFormState> _mapOldPasswordSubmitted(OldPasswordSubmitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      bool isPasswordVerified = await _customerRepository.checkPassword(password: event.oldPassword);
      yield state.update(isSubmitting: false, isOldPasswordVerified: isPasswordVerified, isSuccessOldPassword: isPasswordVerified, isFailureOldPassword: !isPasswordVerified);
    } catch (_) {
      yield state.update(isFailureOldPassword: true, isSubmitting: false);
    }
  }

  Stream<PasswordFormState> _mapNewPasswordSubmittedToState(NewPasswordSubmitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _customerRepository.updatePassword(event.oldPassword, event.password, event.passwordConfirmation, event.customer.identifier);
      yield state.update(isSubmitting: false, isSuccess: true);
      _authenticationBloc.add(CustomerUpdated(customer: customer));
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }

  Stream<PasswordFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false, isSuccessOldPassword: false, isFailureOldPassword: false);
  }
}
