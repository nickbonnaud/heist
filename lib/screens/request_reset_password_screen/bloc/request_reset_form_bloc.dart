import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';

part 'request_reset_form_event.dart';
part 'request_reset_form_state.dart';

class RequestResetFormBloc extends Bloc<RequestResetFormEvent, RequestResetFormState> {
  final AuthenticationRepository _authenticationRepository;
  
  RequestResetFormBloc({required AuthenticationRepository authenticationRepository}) 
    : _authenticationRepository = authenticationRepository,
      super(RequestResetFormState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<RequestResetFormState> emit}) {
    emit(state.update(isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<RequestResetFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      await _authenticationRepository.requestPasswordReset(email: event.email);
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<RequestResetFormState> emit}) {
    emit(state.update(errorMessage: "", isSubmitting: false, isSuccess: false));
  }
}
