import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/tutorial/bloc/tutorial_screen_bloc.dart';
import 'package:heist/screens/tutorial/models/tutorial.dart';

import 'tutorial_card.dart';

class TutorialCards extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._createTutorialCards(context: context)
      ],
    );
  }

  List<Widget> _createTutorialCards({@required BuildContext context}) {
    List<Widget> cards = [];

    BlocProvider.of<TutorialScreenBloc>(context).tutorialCards.forEach((card) {
      cards.add(_createCard(card: card));
    });
    return cards;
  }

  Widget _createCard({@required Tutorial card}) {
    return TutorialCard(tutorialCard: card);
  }
}