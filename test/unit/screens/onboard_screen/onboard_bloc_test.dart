import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/status.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';

void main() {
  group("Onboard Bloc Tests", () {
    late OnboardBloc onboardBloc;
    late int _baseState;

    setUp(() {
      onboardBloc = OnboardBloc(customerStatus: Status(name: "name", code: 100), numberValidPermissions: 1);
      _baseState = onboardBloc.state;
    });

    tearDown(() {
      onboardBloc.close();
    });

    test("Initial state of OnboardBloc is 0", () {
      expect(onboardBloc.state, 0);
    });

    blocTest<OnboardBloc, int>(
      "OnboardBloc OnboardEvent.next yields state + 1",
      build: () => onboardBloc,
      act: (bloc) => bloc.add(OnboardEvent.next),
      expect: () => [_baseState + 1]
    );

    blocTest<OnboardBloc, int>(
      "OnboardBloc OnboardEvent.prev yields state - 1",
      build: () => onboardBloc,
      seed: () {
        _baseState = 2;
        return _baseState;
      },
      act: (bloc) => bloc.add(OnboardEvent.prev),
      expect: () => [_baseState - 1]
    );
  });
}