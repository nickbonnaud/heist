import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _customerRepository;

  CustomerBloc({required CustomerRepository customerRepository})
    : _customerRepository = customerRepository,
      super(CustomerState.initial());

  Customer? get customer => state.customer;
  bool get onboarded => state.customer!.status.code > 103;

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is CustomerAuthenticated) {
      yield* _mapCustomerAuthenticatedToState();
    } else if (event is CustomerLoggedIn) {
      yield* _mapCustomerLoggedInToState(event: event);
    } else if (event is CustomerLoggedOut) {
      yield* _mapCustomerLoggedOutToState();
    } else if (event is CustomerUpdated) {
      yield* _mapCustomerUpdatedToState(event: event);
    }
  }

  Stream<CustomerState> _mapCustomerAuthenticatedToState() async* {
    yield state.update(loading: true);

    try {
      final Customer customer = await _customerRepository.fetchCustomer();
      yield state.update(loading: false, customer: customer);
    } on ApiException catch (exception) {
      yield state.update(loading: false, errorMessage: exception.error);
    }
  }

  Stream<CustomerState> _mapCustomerLoggedInToState({required CustomerLoggedIn event}) async* {
    yield state.update(customer: event.customer, loading: false, errorMessage: "");
  }

  Stream<CustomerState> _mapCustomerLoggedOutToState() async* {
    yield state.update(customer: null, loading: false, errorMessage: "");
  }
  
  Stream<CustomerState> _mapCustomerUpdatedToState({required CustomerUpdated event}) async* {
    yield state.update(customer: event.customer);
  }
}
