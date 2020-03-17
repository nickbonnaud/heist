import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CustomerRepository _customerRepository;

  RegisterBloc({@required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next
  ) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged && event is !PasswordChanged && event is !PasswordConfirmationChanged);
    final debounceStream = events.where((event) => event is EmailChanged || event is PasswordChanged || event is PasswordConfirmationChanged)
      .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
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
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password, String passwordConfirmation) async* {
    final bool isPasswordConfirmationValid = passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password, passwordConfirmation)
      : true;
    yield state.update(isPasswordValid: Validators.isValidPassword(password), isPasswordConfirmationValid: isPasswordConfirmationValid);
  }

  Stream<RegisterState> _mapPasswordConfirmationChangedToState(String password, String passwordConfirmation) async* {
    yield state.update(isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password, passwordConfirmation));
  }

  Stream<RegisterState> _mapSubmittedToState(String email, String password, String passwordConfirmation) async* {
    yield RegisterState.loading();
    try {
      await _customerRepository.register(email: email, password: password, passwordConfirmation: passwordConfirmation);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
