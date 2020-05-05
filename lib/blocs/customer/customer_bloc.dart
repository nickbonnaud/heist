import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:meta/meta.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  
  @override
  CustomerState get initialState => SignedOut();

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is SignIn) {
      yield SignedIn(customer: event.customer);
    } else if(event is SignOut) {
      yield SignedOut();
    } else if (event is UpdateCustomer) {
      yield SignedIn(customer: event.customer);
    }
  }

  Customer get customer => state.customer;
}
