import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CustomerRepository _customerRepository;
  final CustomerBloc _customerBloc;

  AuthenticationBloc({@required CustomerRepository customerRepository, @required CustomerBloc customerBloc})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      _customerBloc = customerBloc;
  
  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }


  Stream<AuthenticationState> _mapAppStartedToState() async* {
    yield Loading();
    try {
      // final bool isSignedIn = await _customerRepository.isSignedIn();
      final bool isSignedIn = true;
      
      if (isSignedIn) {
        final Customer customer = await _customerRepository.fetchCustomer();
        _customerBloc.add(SignIn(customer: customer));
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final Customer customer = await _customerRepository.fetchCustomer();
    _customerBloc.add(SignIn(customer: customer));
    yield Authenticated();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _customerRepository.logout();
    _customerBloc.add(SignOut());
    yield Unauthenticated();
  }
}
