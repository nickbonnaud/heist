import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:meta/meta.dart';

part 'profile_setup_screen_event.dart';
part 'profile_setup_screen_state.dart';

enum Section {
  intro,
  name,
  photo,
  paymentAccount,
  tip
}

class ProfileSetupScreenBloc extends Bloc<ProfileSetupScreenEvent, ProfileSetupScreenState> {
  @override
  ProfileSetupScreenState get initialState => ProfileSetupScreenState.initial();

  @override
  Stream<ProfileSetupScreenState> mapEventToState(ProfileSetupScreenEvent event) async* {
    if (event is SectionCompleted) {
      yield* _mapSectionCompletedToState(event);
    } else if (event is Init) {
      yield* _mapInitToState(event);
    }
  }

  Stream<ProfileSetupScreenState> _mapSectionCompletedToState(SectionCompleted event) async* {
    switch (event.section) {
      case Section.intro:
        yield state.update(isIntroComplete: true);
        break;
      case Section.name:
        yield state.update(isNameComplete: true);
        break;
      case Section.photo:
        yield state.update(isPhotoComplete: true);
        break;
      case Section.tip:
        yield state.update(isTipComplete: true);
        break;
      case Section.paymentAccount:
        yield state.update(isPaymentAccountComplete: true);
        break;
    }
  }

  Stream<ProfileSetupScreenState> _mapInitToState(Init event) async* {
    int status = event.customer.status.code;
    bool isIntroComplete = false;
    bool isNameComplete = false;
    bool isPhotoComplete = false;
    bool isTipSettingsComplete = false;
    bool isPaymentAccountComplete = false;

    if (status == 101) {
      isIntroComplete = true;
      isNameComplete = true;
    } else if (status == 102) {
      isIntroComplete = true;
      isNameComplete = true;
      isPhotoComplete = true;
    } else if (status == 103) {
      isIntroComplete = true;
      isNameComplete = true;
      isPhotoComplete = true;
      isTipSettingsComplete = true;
    } else if (status >= 120) {
      isIntroComplete = true;
      isNameComplete = true;
      isPhotoComplete = true;
      isTipSettingsComplete = true;
      isPaymentAccountComplete = true;
    }
    yield state.update(
      isIntroComplete: isIntroComplete,
      isNameComplete: isNameComplete,
      isPhotoComplete: isPhotoComplete,
      isPaymentAccountComplete: isPaymentAccountComplete,
      isTipComplete: isTipSettingsComplete
    );
    
  }
}
