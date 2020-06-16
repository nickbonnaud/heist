import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CustomerRepository _customerRepository;

  AuthenticationBloc({@required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository;
  
  @override
  AuthenticationState get initialState => AuthenticationState.initial();

  Customer get customer => state.customer;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is Registered) {
      yield* _mapAuthenticatedToState(event);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is CustomerUpdated) {
      yield* _mapCustomerUpdatedToState(event);
    }
  }


  Stream<AuthenticationState> _mapAppStartedToState() async* {
    state.update(loading: true);
    try {
      // final bool isSignedIn = await _customerRepository.isSignedIn();
      final isSignedIn = true;
      
      if (isSignedIn) {
        final Customer customer = await _customerRepository.fetchCustomer();
        yield AuthenticationState.authenticated(customer: customer);
      } else {
        yield state.update(loading: false);
      }
    } catch (_) {
      yield state.update(loading: false);
    }
  }

  Stream<AuthenticationState> _mapAuthenticatedToState(Registered event) async* {
    yield AuthenticationState.authenticated(customer: event.customer);
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final Customer customer = await _customerRepository.fetchCustomer();
    yield AuthenticationState.authenticated(customer: customer);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _customerRepository.logout();
    yield AuthenticationState.unAuthenticated();
  }

  Stream<AuthenticationState> _mapCustomerUpdatedToState(CustomerUpdated event) async* {
    yield state.update(customer: event.customer);
  }
}
