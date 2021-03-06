import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  LoginBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(LoginState.empty());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(Stream<LoginEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged && event is !PasswordChanged);
    final debounceStream = (events.where((event) => event is EmailChanged || event is PasswordChanged))
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password: password));
  }

  Stream<LoginState> _mapSubmittedToState({required String email, required String password}) async* {
    yield LoginState.loading();
    try {
     Customer customer = await _authenticationRepository.login(email: email, password: password);
     _authenticationBloc.add(LoggedIn(customer: customer));
      yield LoginState.success();
    } on ApiException catch (exception) {
      yield LoginState.failure(errorMessage: exception.error);
    }
  }
}
