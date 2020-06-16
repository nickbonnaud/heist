part of 'profile_setup_screen_bloc.dart';

class ProfileSetupScreenState {
  final bool isIntroComplete;
  final bool isNameComplete;
  final bool isPhotoComplete;
  final bool isPaymentAccountComplete;
  final bool isTipComplete;

  ProfileSetupScreenState({
    @required this.isIntroComplete,
    @required this.isNameComplete,
    @required this.isPhotoComplete,
    @required this.isPaymentAccountComplete,
    @required this.isTipComplete
  });

  bool get isComplete => this.isNameComplete && this.isPhotoComplete && this.isPaymentAccountComplete && this.isTipComplete;

  factory ProfileSetupScreenState.initial() {
    return ProfileSetupScreenState(
      isIntroComplete: false,
      isNameComplete: false,
      isPhotoComplete: false,
      isPaymentAccountComplete: false,
      isTipComplete: false
    );
  }

  ProfileSetupScreenState update({
    bool isIntroComplete,
    bool isNameComplete,
    bool isPhotoComplete,
    bool isPaymentAccountComplete,
    bool isTipComplete
  }) {
    return copyWith(
      isIntroComplete: isIntroComplete,
      isNameComplete: isNameComplete,
      isPhotoComplete: isPhotoComplete,
      isPaymentAccountComplete: isPaymentAccountComplete,
      isTipComplete: isTipComplete
    );
  }
  
  ProfileSetupScreenState copyWith({
    bool isIntroComplete,
    bool isNameComplete,
    bool isPhotoComplete,
    bool isPaymentAccountComplete,
    bool isTipComplete
  }) {
    return ProfileSetupScreenState(
      isIntroComplete: isIntroComplete ?? this.isIntroComplete,
      isNameComplete: isNameComplete ?? this.isNameComplete,
      isPhotoComplete: isPhotoComplete ?? this.isPhotoComplete,
      isPaymentAccountComplete: isPaymentAccountComplete ?? this.isPaymentAccountComplete,
      isTipComplete: isTipComplete ?? this.isTipComplete
    );
  }

  @override
  String toString() {
    return '''ProfileSetupScreenState {
      isIntroComplete: $isIntroComplete,
      isNameComplete: $isNameComplete,
      isPhotoComplete: $isPhotoComplete,
      isPaymentAccountComplete: $isPaymentAccountComplete,
      isTipComplete: $isTipComplete
    }''';
  }
}
