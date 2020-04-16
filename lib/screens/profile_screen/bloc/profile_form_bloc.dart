import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_form_event.dart';
part 'profile_form_state.dart';

class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  final ProfileRepository _profileRepository;
  final CustomerBloc _customerBloc;

  ProfileFormBloc({@required ProfileRepository profileRepository, @required CustomerBloc customerBloc})
    : assert(profileRepository != null && customerBloc != null),
      _profileRepository = profileRepository,
      _customerBloc = customerBloc;
  
  @override
  ProfileFormState get initialState => ProfileFormState.initial();

  @override
  Stream<ProfileFormState> transformEvents(
    Stream<ProfileFormEvent> events,
    Stream<ProfileFormState> Function(ProfileFormEvent event) next
  ) {
    final nonDebounceStream = events.where((event) => event is !FirstNameChanged && event is !LastNameChanged);
    final debounceStream = events.where((event) => event is FirstNameChanged || event is LastNameChanged)
      .debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
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
    yield state.update(isFirstNameValid: Validators.isValidName(event.firstName));
  }

  Stream<ProfileFormState> _mapLastNameChangedToState(LastNameChanged event) async* {
    yield state.update(isLastNameValid: Validators.isValidName(event.lastName));
  }

  Stream<ProfileFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Profile profile = await _sendProfileData(event.firstName, event.lastName, event.customer);
      _updatCustomerBloc(event.customer, profile);
      yield state.update(isSubmitting: false, isSuccess: true);
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }
  
  Stream<ProfileFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false);
  }

  Future<Profile> _sendProfileData(String firstName, String lastName, Customer customer) {
    return _profileRepository.update(firstName: firstName, lastName: lastName, profileIdentifier: customer.profile.identifier);
  }

  void _updatCustomerBloc(Customer customer, Profile profile) {
    _customerBloc.add(UpdateCustomer(customer: customer.update(profile: profile)));
  }
}
