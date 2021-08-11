import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  SignOutBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(SignOutState.initial());

  @override
  Stream<SignOutState> mapEventToState(SignOutEvent event) async* {
    if (event is Submitted) {
      yield* _mapSubmittedToState();
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<SignOutState> _mapSubmittedToState() async* {
    if (!state.isSubmitting) {
      yield state.update(isSubmitting: true);

      try {
        final bool loggedOut = await _authenticationRepository.logout();
        if (loggedOut) {
          yield state.update(isSubmitting: false, isSuccess: true);
          _authenticationBloc.add(LoggedOut());
        } else {
          yield state.update(isSubmitting: false, errorMessage: "An error occurred. Please try again.");
        }
      } on ApiException catch (exception) {
        yield state.update(isSubmitting: false, errorMessage: exception.error);
      }
    }
  }

  Stream<SignOutState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "");
  }
}
