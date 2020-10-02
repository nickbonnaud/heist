part of 'tutorial_screen_bloc.dart';

@immutable
class TutorialScreenState {
  final List<Tutorial> tutorialCards;
  final int currentIndex;

  TutorialScreenState({
    @required this.tutorialCards,
    @required this.currentIndex,
  });

  factory TutorialScreenState.initial({@required List<Tutorial> tutorialCards}) {
    return TutorialScreenState(
      tutorialCards: tutorialCards,
      currentIndex: tutorialCards.length - 1,
    );
  }

  TutorialScreenState updateNext() {
    this.tutorialCards[this.currentIndex] = this.tutorialCards[this.currentIndex].update(dismissed: true);
    return TutorialScreenState(
      tutorialCards: this.tutorialCards,
      currentIndex: this.currentIndex - 1
    );
  }

  TutorialScreenState updatePrevious() {
    this.tutorialCards[this.currentIndex + 1] = this.tutorialCards[this.currentIndex + 1].update(dismissed: false);
    return TutorialScreenState(
      tutorialCards: this.tutorialCards,
      currentIndex: this.currentIndex + 1
    );
  }
}
