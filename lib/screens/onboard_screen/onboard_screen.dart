import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:heist/screens/onboard_screen/widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {
  final bool _customerOnboarded;
  final bool _permissionsReady;

  OnboardScreen({@required bool customerOnboarded, @required permissionsReady})
    : assert(customerOnboarded != null && permissionsReady != null),
      _customerOnboarded = customerOnboarded,
      _permissionsReady = permissionsReady;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: BlocProvider<OnboardBloc>(
        create: (BuildContext context) => OnboardBloc(),
        child: OnboardBody(customerOnboarded: _customerOnboarded, permissionsReady: _permissionsReady),
      ),
    );
  }
}