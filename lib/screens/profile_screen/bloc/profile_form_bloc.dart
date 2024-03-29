import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/resources/helpers/validators.dart';
import 'package:meta/meta.dart';

part 'profile_form_event.dart';
part 'profile_form_state.dart';

class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  final ProfileRepository _profileRepository;
  final CustomerBloc _customerBloc;

  final Duration _debounceTime = const Duration(milliseconds: 300);

  ProfileFormBloc({
    required ProfileRepository profileRepository,
    required CustomerBloc customerBloc
  })
    : _profileRepository = profileRepository,
      _customerBloc = customerBloc,
      super(ProfileFormState.initial(profile: customerBloc.customer!.profile)) { _eventHandler(); }

  void _eventHandler() {
    on<FirstNameChanged>((event, emit) => _mapFirstNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<LastNameChanged>((event, emit) => _mapLastNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapFirstNameChangedToState({required FirstNameChanged event, required Emitter<ProfileFormState> emit}) {
    emit(state.update(firstName: event.firstName, isFirstNameValid: Validators.isValidName(name: event.firstName)));
  }

  void _mapLastNameChangedToState({required LastNameChanged event, required Emitter<ProfileFormState> emit}) {
    emit(state.update(lastName: event.lastName, isLastNameValid: Validators.isValidName(name: event.lastName)));
  }

  Future<void> _mapSubmittedToState({required Emitter<ProfileFormState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      Customer customer = await _profileRepository.update(firstName: state.firstName, lastName: state.lastName, profileIdentifier: _customerBloc.customer!.profile.identifier);
      _customerBloc.add(CustomerUpdated(customer: customer));
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }
  
  void _mapResetToState({required Emitter<ProfileFormState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
