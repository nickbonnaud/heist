import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  RegisterBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(RegisterState.empty());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(Stream<RegisterEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged && event is !PasswordChanged && event is !PasswordConfirmationChanged);
    final debounceStream = events.where((event) => event is EmailChanged || event is PasswordChanged || event is PasswordConfirmationChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password, event.passwordConfirmation);
    } else if (event is PasswordConfirmationChanged) {
      yield* _mapPasswordConfirmationChangedToState(event.passwordConfirmation, event.password);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event.email, event.password, event.passwordConfirmation);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: email));
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password, String passwordConfirmation) async* {
    final bool isPasswordConfirmationValid = passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: password, passwordConfirmation: passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(password: password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<RegisterState> _mapPasswordConfirmationChangedToState(String password, String passwordConfirmation) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: password, passwordConfirmation: passwordConfirmation));
  }

  Stream<RegisterState> _mapSubmittedToState(String email, String password, String passwordConfirmation) async* {
    yield RegisterState.loading();
    try {
      Customer customer = await _authenticationRepository.register(email: email, password: password, passwordConfirmation: passwordConfirmation);
      _authenticationBloc.add(LoggedIn(customer: customer));
      yield RegisterState.success();
    } on ApiException catch (exception) {
      yield RegisterState.failure(errorMessage: exception.error);
    }
  }

  Stream<RegisterState> _mapResetToState() async* {
    yield state.update(isSubmitting: false, errorMessage: "");
  }
}
