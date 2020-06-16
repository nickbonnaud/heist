import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_name_form_event.dart';
part 'profile_name_form_state.dart';

class ProfileNameFormBloc extends Bloc<ProfileNameFormEvent, ProfileNameFormState> {
  final ProfileRepository _profileRepository;
  final AuthenticationBloc _authenticationBloc;
  
  ProfileNameFormBloc({@required ProfileRepository profileRepository, @required AuthenticationBloc authenticationBloc})
    : assert(profileRepository != null && authenticationBloc != null),
      _profileRepository = profileRepository,
      _authenticationBloc = authenticationBloc;
  
  @override
  ProfileNameFormState get initialState => ProfileNameFormState.initial();

  @override
  Stream<Transition<ProfileNameFormEvent, ProfileNameFormState>> transformEvents(Stream<ProfileNameFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !FirstNameChanged && event is !LastNameChanged);
    final debounceStream = events.where((event) => event is FirstNameChanged || event is LastNameChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<ProfileNameFormState> mapEventToState(ProfileNameFormEvent event) async* {
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

  Stream<ProfileNameFormState> _mapFirstNameChangedToState(FirstNameChanged event) async* {
    yield state.update(isFirstNameValid: Validators.isValidName(event.firstName));
  }

  Stream<ProfileNameFormState> _mapLastNameChangedToState(LastNameChanged event) async* {
    yield state.update(isLastNameValid: Validators.isValidName(event.lastName));
  }

  Stream<ProfileNameFormState> _mapSubmittedToState(Submitted event) async* {
    yield state.update(isSubmitting: true);
    try {
      Customer customer = await _sendProfileData(firstName: event.firstName, lastName: event.lastName, customer: event.customer);
      _updatAuthenticationBloc(customer: customer);
      yield state.update(isSubmitting: false, isSuccess: true);
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }
  
  Stream<ProfileNameFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false);
  }

  Future<Customer> _sendProfileData({@required String firstName, @required String lastName, @required Customer customer}) {
    return _profileRepository.store(firstName: firstName, lastName: lastName);
  }

  void _updatAuthenticationBloc({@required Customer customer}) {
    _authenticationBloc.add(CustomerUpdated(customer: customer));
  }
}
