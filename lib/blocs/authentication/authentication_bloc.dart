import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final CustomerBloc _customerBloc;

  AuthenticationBloc({required AuthenticationRepository authenticationRepository, required CustomerBloc customerBloc})
    : _authenticationRepository = authenticationRepository,
      _customerBloc = customerBloc,
      super(Unknown()) { _eventHandler(); }

  void _eventHandler() {
    on<InitAuthentication>((event, emit) async => await _mapInitAuthenticationToState(emit: emit));
    on<LoggedIn>((event, emit) => _mapLoggedInToState(event: event, emit: emit));
    on<LoggedOut>((event, emit) => _mapLoggedOutToState(emit: emit));
  }

  bool get isAuthenticated => state is Authenticated;

  Future<void> _mapInitAuthenticationToState({required Emitter<AuthenticationState> emit}) async {
    // TEST CHANGE //
    
    final bool isSignedIn = await _authenticationRepository.isSignedIn();

    // final bool isSignedIn = true;
    
    if (isSignedIn) {
      _customerBloc.add(CustomerAuthenticated());
      emit(const Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void _mapLoggedInToState({required LoggedIn event, required Emitter<AuthenticationState> emit}) {
    _customerBloc.add(CustomerLoggedIn(customer: event.customer));
    emit(const Authenticated());
  }

  void _mapLoggedOutToState({required Emitter<AuthenticationState> emit}) {
    _customerBloc.add(CustomerLoggedOut());
    emit(Unauthenticated());
  }
}
