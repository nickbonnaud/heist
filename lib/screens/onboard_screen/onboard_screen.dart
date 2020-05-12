import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:heist/screens/onboard_screen/widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(),
        child: OnboardBody(),
      ),
    );
  }
}