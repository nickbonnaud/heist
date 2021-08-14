import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final CustomerBloc _customerBloc;

  AuthenticationBloc({required AuthenticationRepository authenticationRepository, required CustomerBloc customerBloc})
    : _authenticationRepository = authenticationRepository,
      _customerBloc = customerBloc,
      super(Unknown());

  bool get isAuthenticated => state is Authenticated;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event: event);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapInitToState() async* {
    // TEST CHANGE //
    
    // final bool isSignedIn = await _authenticationRepository.isSignedIn();

    final bool isSignedIn = true;

    if (isSignedIn) {
      _customerBloc.add(CustomerAuthenticated());
      yield Authenticated();
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState({required LoggedIn event}) async* {
    _customerBloc.add(CustomerLoggedIn(customer: event.customer));
    yield Authenticated();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _customerBloc.add(CustomerLoggedOut());
    yield Unauthenticated();
  }
}
