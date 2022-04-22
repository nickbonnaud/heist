import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';

import 'widgets/login_form/bloc/login_bloc.dart';
import 'widgets/login_form/login_form.dart';
import 'widgets/welcome_label.dart';

class Login extends StatelessWidget {
  final PageController _pageController;

  const Login({required PageController pageController, Key? key})
    : _pageController = pageController,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const WelcomeLabel(),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          ),
          child: LoginForm(pageController: _pageController),
        ),
      ],
    );
  }
}