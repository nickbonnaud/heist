import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300);

  RegisterBloc({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(RegisterState.empty()) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordChanged>((event, emit) => _mapPasswordChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PasswordConfirmationChanged>((event, emit) => _mapPasswordConfirmationChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<RegisterState> emit}) {
    emit(state.update(email: event.email, isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  void _mapPasswordChangedToState({required PasswordChanged event, required Emitter<RegisterState> emit}) {
    final bool isPasswordConfirmationValid = state.passwordConfirmation.isNotEmpty
      ? Validators.isPasswordConfirmationValid(password: event.password, passwordConfirmation: state.passwordConfirmation)
      : false;
    emit(state.update(password: event.password, isPasswordValid: Validators.isValidPassword(password: event.password), isPasswordConfirmationValid: isPasswordConfirmationValid));
  }

  void _mapPasswordConfirmationChangedToState({required PasswordConfirmationChanged event, required Emitter<RegisterState> emit}) {
    emit(state.update(passwordConfirmation: event.passwordConfirmation, isPasswordConfirmationValid: Validators.isPasswordConfirmationValid(password: state.password, passwordConfirmation: event.passwordConfirmation)));
  }

  Future<void> _mapSubmittedToState({required Emitter<RegisterState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      Customer customer = await _authenticationRepository.register(email: state.email, password: state.password, passwordConfirmation: state.passwordConfirmation);
      _authenticationBloc.add(LoggedIn(customer: customer));
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<RegisterState> emit}) {
    emit(state.update(isSubmitting: false, errorMessage: ""));
  }
}
