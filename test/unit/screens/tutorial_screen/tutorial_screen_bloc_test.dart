import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';
import 'package:heist/screens/tutorial_screen/models/tutorial.dart';

void main() {
  group("Tutorial Screen Bloc Tests", () {
    late TutorialScreenBloc tutorialScreenBloc;
    late TutorialScreenState _baseState;

    setUp(() {
      tutorialScreenBloc = TutorialScreenBloc();
      _baseState = tutorialScreenBloc.state;
    });

    tearDown(() {
      tutorialScreenBloc.close();
    });

    test("Initial state of TutorialScreenBloc is TutorialScreenState.initial", () {
      expect(tutorialScreenBloc.state, _baseState);
    });

    test("TutorialScreenBloc creates tutorial cards", () {
      expect(_baseState.tutorialCards.isNotEmpty, true);
      expect(_baseState.tutorialCards, isA<List<Tutorial>>());
    });

    
    blocTest<TutorialScreenBloc, TutorialScreenState>(
      "TutorialScreenBloc Next event updates current tutorial card to dismissed and reduces currentIndex by 1",
      build: () {
        expect(_baseState.currentIndex, _baseState.tutorialCards.length - 1);
        expect(_baseState.tutorialCards.any((card) => card.dismissed), false);
        return tutorialScreenBloc;
      },
      act: (bloc) {
        bloc.add(Next());
      },
      expect: () => [_baseState.updateNext()],
      verify: (_) {
        expect(tutorialScreenBloc.state.currentIndex, _baseState.tutorialCards.length - 2);
        expect(tutorialScreenBloc.tutorialCards.any((card) => card.dismissed), true);
      }
    );

    blocTest<TutorialScreenBloc, TutorialScreenState>(
      "TutorialScreenBloc Previous event updates current tutorial card to not dismissed and adds currentIndex by 1",
      build: () => tutorialScreenBloc,
      seed: () {
        Tutorial card = _baseState.tutorialCards[_baseState.tutorialCards.length  - 1].update(dismissed: true);
        _baseState.tutorialCards[_baseState.tutorialCards.length  - 1] = card;
        _baseState = TutorialScreenState(currentIndex: _baseState.tutorialCards.length - 2, tutorialCards: _baseState.tutorialCards);
        return _baseState;
      },
      act: (bloc) {
        bloc.add(Previous());
      },
      expect: () => [_baseState.updatePrevious()],
      verify: (_) {
        expect(tutorialScreenBloc.state.currentIndex, _baseState.tutorialCards.length - 1);
        expect(tutorialScreenBloc.tutorialCards.any((card) => card.dismissed), false);
      }
    );
  });
}