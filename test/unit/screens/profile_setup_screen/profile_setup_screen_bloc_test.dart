import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/status.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';

void main() {
  group("Profile Setup Screen Bloc Tests", () {
    late ProfileSetupScreenBloc profileSetupScreenBloc;
    late ProfileSetupScreenState _baseState;

    setUp(() {
      profileSetupScreenBloc = ProfileSetupScreenBloc();
      _baseState = profileSetupScreenBloc.state;
    });

    tearDown(() {
      profileSetupScreenBloc.close();
    });

    test("Initial state of ProfileSetupScreenBloc is ProfileSetupScreenState.initial()", () {
      expect(profileSetupScreenBloc.state, ProfileSetupScreenState.initial());
    });

    test("ProfileSetupScreenBloc can get incompleteSections", () {
      expect(profileSetupScreenBloc.incompleteSections, isA<List<Section>>());
    });

    blocTest<ProfileSetupScreenBloc, ProfileSetupScreenState>(
      "ProfileSetupScreenBloc SectionCompleted event yields state: [isTipComplete: true]",
      build: () => profileSetupScreenBloc,
      act: (bloc) => bloc.add(SectionCompleted(section: Section.tip)),
      expect: () => [_baseState.update(isTipComplete: true)]
    );

    blocTest<ProfileSetupScreenBloc, ProfileSetupScreenState>(
      "ProfileSetupScreenBloc Init event yields state: [isIntroComplete = true, isNameComplete = true, isPhotoComplete = true]",
      build: () => profileSetupScreenBloc,
      act: (bloc) => bloc.add(Init(status: Status(name: "name", code: 102))),
      expect: () => [_baseState.update(isIntroComplete: true, isNameComplete: true, isPhotoComplete: true)]
    );
  });
}