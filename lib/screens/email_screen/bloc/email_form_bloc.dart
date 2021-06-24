import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'email_form_event.dart';
part 'email_form_state.dart';

class EmailFormBloc extends Bloc<EmailFormEvent, EmailFormState> {
  final CustomerRepository _customerRepository;
  final CustomerBloc _customerBloc;


  EmailFormBloc({required CustomerRepository customerRepository, required CustomerBloc customerBloc})
    : _customerRepository = customerRepository,
      _customerBloc = customerBloc,
      super(EmailFormState.initial());

  @override
  Stream<Transition<EmailFormEvent, EmailFormState>> transformEvents(Stream<EmailFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged);
    final debounceStream = events.where((event) => event is EmailChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<EmailFormState> mapEventToState(EmailFormEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<EmailFormState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<EmailFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _customerRepository.updateEmail(email: event.email, customerId: event.identifier);
      yield state.update(isSubmitting: false, isSuccess: true);
      _customerBloc.add(CustomerUpdated(customer: customer));
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<EmailFormState> _mapResetToState() async* {
    yield state.update(errorMessage: "", isSuccess: false);
  }
}
