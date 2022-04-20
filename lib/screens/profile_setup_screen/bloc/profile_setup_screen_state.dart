part of 'profile_setup_screen_bloc.dart';

@immutable
class ProfileSetupScreenState extends Equatable {
  final bool isIntroComplete;
  final bool isNameComplete;
  final bool isPhotoComplete;
  final bool isPaymentAccountComplete;
  final bool isTipComplete;

  const ProfileSetupScreenState({
    required this.isIntroComplete,
    required this.isNameComplete,
    required this.isPhotoComplete,
    required this.isPaymentAccountComplete,
    required this.isTipComplete
  });

  bool get isComplete => isNameComplete && isPhotoComplete && isPaymentAccountComplete && isTipComplete;
  List<Section> get incompleteSections {
    List<Section> incompleteSections = [];
    if (!isPaymentAccountComplete) incompleteSections.add(Section.paymentAccount);
    if (!isTipComplete) incompleteSections.add(Section.tip);
    if (!isPhotoComplete) incompleteSections.add(Section.photo);
    if (!isNameComplete) incompleteSections.add(Section.name);

    return incompleteSections;
  }

  factory ProfileSetupScreenState.initial() {
    return const ProfileSetupScreenState(
      isIntroComplete: false,
      isNameComplete: false,
      isPhotoComplete: false,
      isPaymentAccountComplete: false,
      isTipComplete: false
    );
  }

  ProfileSetupScreenState update({
    bool? isIntroComplete,
    bool? isNameComplete,
    bool? isPhotoComplete,
    bool? isPaymentAccountComplete,
    bool? isTipComplete
  }) => ProfileSetupScreenState(
    isIntroComplete: isIntroComplete ?? this.isIntroComplete,
    isNameComplete: isNameComplete ?? this.isNameComplete,
    isPhotoComplete: isPhotoComplete ?? this.isPhotoComplete,
    isPaymentAccountComplete: isPaymentAccountComplete ?? this.isPaymentAccountComplete,
    isTipComplete: isTipComplete ?? this.isTipComplete
  );

  @override
  List<Object> get props => [isIntroComplete, isNameComplete, isPhotoComplete, isPaymentAccountComplete, isTipComplete];

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
