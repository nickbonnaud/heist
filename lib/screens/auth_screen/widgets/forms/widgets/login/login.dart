import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';

import 'widgets/login_form/bloc/login_bloc.dart';
import 'widgets/login_form/login_form.dart';
import 'widgets/welcome_label.dart';

class Login extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final PageController _pageController;
  final bool _permissionsReady;
  final bool _customerOnboarded;

  Login({
    required AuthenticationRepository authenticationRepository,
    required PageController pageController,
    required bool permissionsReady,
    required bool customerOnboarded
  })
    : _authenticationRepository = authenticationRepository,
      _pageController = pageController,
      _permissionsReady = permissionsReady,
      _customerOnboarded = customerOnboarded;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WelcomeLabel(),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(authenticationRepository: _authenticationRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
          child: LoginForm(
            pageController: _pageController,
            permissionsReady: _permissionsReady,
            customerOnboarded: _customerOnboarded,
            ),
        ),
      ],
    );
  }
}