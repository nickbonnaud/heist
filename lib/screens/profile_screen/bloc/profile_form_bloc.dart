import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_form_event.dart';
part 'profile_form_state.dart';

class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  final ProfileRepository _profileRepository;
  final CustomerBloc _customerBloc;

  ProfileFormBloc({
    required ProfileRepository profileRepository,
    required CustomerBloc customerBloc
  })
    : _profileRepository = profileRepository,
      _customerBloc = customerBloc,
      super(ProfileFormState.initial());

  @override
  Stream<Transition<ProfileFormEvent, ProfileFormState>> transformEvents(Stream<ProfileFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !FirstNameChanged && event is !LastNameChanged);
    final debounceStream = events.where((event) => event is FirstNameChanged || event is LastNameChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<ProfileFormState> mapEventToState(ProfileFormEvent event) async* {
    if (event is FirstNameChanged) {
      yield* _mapFirstNameChangedToState(event);
    } else if (event is LastNameChanged) {
      yield* _mapLastNameChangedToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<ProfileFormState> _mapFirstNameChangedToState(FirstNameChanged event) async* {
    yield state.update(isFirstNameValid: Validators.isValidName(name: event.firstName));
  }

  Stream<ProfileFormState> _mapLastNameChangedToState(LastNameChanged event) async* {
    yield state.update(isLastNameValid: Validators.isValidName(name: event.lastName));
  }

  Stream<ProfileFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _profileRepository.update(firstName: event.firstName, lastName: event.lastName, profileIdentifier: event.profileIdentifier);
      _customerBloc.add(CustomerUpdated(customer: customer));
      yield state.update(isSubmitting: false, isSuccess: true);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }
  
  Stream<ProfileFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "");
  }
}
