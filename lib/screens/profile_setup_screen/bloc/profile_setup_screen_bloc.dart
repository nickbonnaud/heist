import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/customer.dart';
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
  
  ProfileSetupScreenBloc() : super(ProfileSetupScreenState.initial());

  List<Section> get incompleteSections => state.incompleteSections;
  
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
    yield state.update(
      isIntroComplete: isIntroComplete,
      isNameComplete: isNameComplete,
      isPhotoComplete: isPhotoComplete,
      isPaymentAccountComplete: isPaymentAccountComplete,
      isTipComplete: isTipSettingsComplete
    );
    
  }
}
