import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'email_form_event.dart';
part 'email_form_state.dart';

class EmailFormBloc extends Bloc<EmailFormEvent, EmailFormState> {
  final CustomerRepository _customerRepository;
  final CustomerBloc _customerBloc;


  EmailFormBloc({@required CustomerRepository customerRepository, @required CustomerBloc customerBloc})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      _customerBloc = customerBloc;
  
  @override
  EmailFormState get initialState => EmailFormState.initial();

  @override
  Stream<EmailFormState> transformEvents(
    Stream<EmailFormEvent> events,
    Stream<EmailFormState> Function(EmailFormEvent event) next
  ) {
    final nonDebounceStream = events.where((event) => event is !EmailChanged);
    final debounceStream = events.where((event) => event is EmailChanged)
      .debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }
  
  @override
  Stream<EmailFormState> mapEventToState(EmailFormEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<EmailFormState> _mapEmailChangedToState(EmailChanged event) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(event.email));
  }

  Stream<EmailFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _customerRepository.updateEmail(event.email, event.customer.identifier);
      yield state.update(isSubmitting: false, isSuccess: true);
      _customerBloc.add(UpdateCustomer(customer: customer));
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }

  Stream<EmailFormState> _mapResetToState() async* {
    yield state.update(isFailure: false, isSuccess: false);
  }
}
