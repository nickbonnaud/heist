part of 'tutorial_screen_bloc.dart';

@immutable
class TutorialScreenState extends Equatable {
  final List<Tutorial> tutorialCards;
  final int currentIndex;

  const TutorialScreenState({
    required this.tutorialCards,
    required this.currentIndex,
  });

  factory TutorialScreenState.initial({required List<Tutorial> tutorialCards}) {
    return TutorialScreenState(
      tutorialCards: tutorialCards,
      currentIndex: tutorialCards.length - 1,
    );
  }

  TutorialScreenState updateNext() {
    tutorialCards[currentIndex] = tutorialCards[currentIndex].update(dismissed: true);
    return TutorialScreenState(
      tutorialCards: tutorialCards,
      currentIndex: currentIndex - 1
    );
  }

  TutorialScreenState updatePrevious() {
    tutorialCards[currentIndex + 1] = tutorialCards[currentIndex + 1].update(dismissed: false);
    return TutorialScreenState(
      tutorialCards: tutorialCards,
      currentIndex: currentIndex + 1
    );
  }

  @override
  List<Object> get props => [tutorialCards, currentIndex];

  @override
  String toString() => 'TutorialScreenState { tutorialCards: $tutorialCards, currentIndex: $currentIndex }';
}
