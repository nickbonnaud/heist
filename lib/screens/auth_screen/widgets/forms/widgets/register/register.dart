import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';

import 'widgets/register_form/bloc/register_bloc.dart';
import 'widgets/register_form/register_form.dart';
import 'widgets/welcome_label.dart';

class Register extends StatelessWidget {
  final PageController _pageController;

  const Register({required PageController pageController, Key? key})
    : _pageController = pageController,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const WelcomeLabel(),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
          ),
          child: RegisterForm(pageController: _pageController),
        ),
      ],
    );
  }
}