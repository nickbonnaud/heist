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
      super(SignOutState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Submitted>((event, emit) => _mapSubmittedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapSubmittedToState({required Emitter<SignOutState> emit}) async {
    if (!state.isSubmitting) {
      emit(state.update(isSubmitting: true));

      try {
        final bool loggedOut = await _authenticationRepository.logout();
        if (loggedOut) {
          emit(state.update(isSubmitting: false, isSuccess: true));
          _authenticationBloc.add(LoggedOut());
        } else {
          emit(state.update(isSubmitting: false, errorMessage: "An error occurred. Please try again."));
        }
      } on ApiException catch (exception) {
        emit(state.update(isSubmitting: false, errorMessage: exception.error));
      }
    }
  }

  void _mapResetToState({required Emitter<SignOutState> emit}) async {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
