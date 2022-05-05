import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';

part 'email_form_event.dart';
part 'email_form_state.dart';

class EmailFormBloc extends Bloc<EmailFormEvent, EmailFormState> {
  final CustomerRepository _customerRepository;
  final CustomerBloc _customerBloc;

  EmailFormBloc({required CustomerRepository customerRepository, required CustomerBloc customerBloc})
    : _customerRepository = customerRepository,
      _customerBloc = customerBloc,
      super(EmailFormState.initial(email: customerBloc.customer!.email)) { _eventHandler(); }

  void _eventHandler() {
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: const Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapEmailChangedToState({required EmailChanged event, required Emitter<EmailFormState> emit}) {
    emit(state.update(email: event.email, isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<EmailFormState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      Customer customer = await _customerRepository.updateEmail(email: state.email, customerId: _customerBloc.customer!.identifier);
      emit(state.update(isSubmitting: false, isSuccess: true));
      _customerBloc.add(CustomerUpdated(customer: customer));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<EmailFormState> emit}) {
    emit(state.update(errorMessage: "", isSuccess: false));
  }
}
