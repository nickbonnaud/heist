import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/status.dart';
import 'package:meta/meta.dart';

part 'profile_setup_screen_event.dart';
part 'profile_setup_screen_state.dart';

enum Section {
  paymentAccount,
  tip,
  photo,
  name,
}

class ProfileSetupScreenBloc extends Bloc<ProfileSetupScreenEvent, ProfileSetupScreenState> {
  
  ProfileSetupScreenBloc()
    : super(ProfileSetupScreenState.initial()) { _eventHandler(); }

  List<Section> get incompleteSections => state.incompleteSections;
  
  void _eventHandler() {
    on<SectionCompleted>((event, emit) => _mapSectionCompletedToState(event: event, emit: emit));
    on<Init>((event, emit) => _mapInitToState(event: event, emit: emit));
  }

  void _mapSectionCompletedToState({required SectionCompleted event, required Emitter<ProfileSetupScreenState> emit}) {
    switch (event.section) {
      case Section.name:
        emit(state.update(isNameComplete: true));
        break;
      case Section.photo:
        emit(state.update(isPhotoComplete: true));
        break;
      case Section.tip:
        emit(state.update(isTipComplete: true));
        break;
      case Section.paymentAccount:
        emit(state.update(isPaymentAccountComplete: true));
        break;
    }
  }

  void _mapInitToState({required Init event, required Emitter<ProfileSetupScreenState> emit}) {
    int statusCode = event.status.code;
    bool isIntroComplete = false;
    bool isNameComplete = false;
    bool isPhotoComplete = false;
    bool isTipSettingsComplete = false;
    bool isPaymentAccountComplete = false;

    if (statusCode == 101) {
      isIntroComplete = true;
      isNameComplete = true;
    } else if (statusCode == 102) {
      isIntroComplete = true;
      isNameComplete = true;
      isPhotoComplete = true;
    } else if (statusCode == 103) {
      isIntroComplete = true;
      isNameComplete = true;
      isPhotoComplete = true;
      isTipSettingsComplete = true;
    } else if (statusCode >= 120) {
      isIntroComplete = true;
      isNameComplete = true;
      isPhotoComplete = true;
      isTipSettingsComplete = true;
      isPaymentAccountComplete = true;
    }
    
    emit(state.update(
      isIntroComplete: isIntroComplete,
      isNameComplete: isNameComplete,
      isPhotoComplete: isPhotoComplete,
      isPaymentAccountComplete: isPaymentAccountComplete,
      isTipComplete: isTipSettingsComplete
    ));
  }
}
