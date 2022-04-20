import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/tutorial_screen/bloc/tutorial_screen_bloc.dart';

import 'widgets/tutorial_cards.dart';

class TutorialScreen extends StatelessWidget {

  const TutorialScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocProvider<TutorialScreenBloc>(
          create: (_) => TutorialScreenBloc(),
          child: const TutorialCards(),
        )
      )
    );
  }
}