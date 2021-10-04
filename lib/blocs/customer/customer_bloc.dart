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
      super(CustomerState.initial()) { _eventHandler(); }

  Customer? get customer => state.customer;
  bool get onboarded => state.onboarded;

  void _eventHandler() {
    on<CustomerAuthenticated>((event, emit) => _mapCustomerAuthenticatedToState(emit: emit));
    on<CustomerLoggedIn>((event, emit) => _mapCustomerLoggedInToState(event: event, emit: emit));
    on<CustomerLoggedOut>((event, emit) => _mapCustomerLoggedOutToState(emit: emit));
    on<CustomerUpdated>((event, emit) => _mapCustomerUpdatedToState(event: event, emit: emit));
  }
  
  void _mapCustomerAuthenticatedToState({required Emitter<CustomerState> emit}) async {
    emit(state.update(loading: true));

    try {
      final Customer customer = await _customerRepository.fetchCustomer();
      emit(state.update(loading: false, customer: customer));
    } on ApiException catch (exception) {
      emit(state.update(loading: false, errorMessage: exception.error));
    }
  }

  void _mapCustomerLoggedInToState({required CustomerLoggedIn event, required Emitter<CustomerState> emit}) async {
    emit(state.update(customer: event.customer, loading: false, errorMessage: ""));
  }

  void _mapCustomerLoggedOutToState({required Emitter<CustomerState> emit}) async {
    emit(state.update(customer: null, loading: false, errorMessage: ""));
  }
  
  void _mapCustomerUpdatedToState({required CustomerUpdated event, required Emitter<CustomerState> emit}) async {
    emit(state.update(customer: event.customer));
  }
}
