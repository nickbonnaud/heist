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
      await _testSleep();
      final bool isSignedIn = await _customerRepository.isSignedIn();
      if (isSignedIn) {
        final Customer customer = await _customerRepository.getCustomer();
        yield Authenticated(customer: customer);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Future<void> _testSleep() async {
    return await Future.delayed(Duration(seconds: 5));
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final Customer customer = await _customerRepository.getCustomer();
    yield Authenticated(customer: customer);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _customerRepository.logout();
    yield Unauthenticated();
  }
}
