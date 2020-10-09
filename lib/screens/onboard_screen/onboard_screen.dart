import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/onboard_bloc.dart';
import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(),
        child: OnboardBody(),
      ),
    );
  }
}