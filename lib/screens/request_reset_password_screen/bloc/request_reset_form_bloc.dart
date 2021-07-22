import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'request_reset_form_event.dart';
part 'request_reset_form_state.dart';

class RequestResetFormBloc extends Bloc<RequestResetFormEvent, RequestResetFormState> {
  final AuthenticationRepository _authenticationRepository;
  
  RequestResetFormBloc({required AuthenticationRepository authenticationRepository}) 
    : _authenticationRepository = authenticationRepository,
      super(RequestResetFormState.initial());

  @override
  Stream<Transition<RequestResetFormEvent, RequestResetFormState>> transformEvents(Stream<RequestResetFormEvent> events, TransitionFunction<RequestResetFormEvent, RequestResetFormState> transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged);
    final debounceStream = events.where((event) => event is EmailChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<RequestResetFormState> mapEventToState(RequestResetFormEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<RequestResetFormState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<RequestResetFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      await _authenticationRepository.requestPasswordReset(email: event.email);
      yield state.update(isSubmitting: false, isSuccess: true);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<RequestResetFormState> _mapResetToState() async* {
    yield state.update(errorMessage: "", isSuccess: false);
  }
}
