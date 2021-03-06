import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'widgets/register_form/bloc/register_bloc.dart';
import 'widgets/register_form/register_form.dart';
import 'widgets/welcome_label.dart';

class Register extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;
  final PageController _pageController;

  Register({
    required AuthenticationRepository authenticationRepository,
    required AuthenticationBloc authenticationBloc,
    required PageController pageController
  })
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      _pageController = pageController;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        WelcomeLabel(),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(authenticationRepository: _authenticationRepository, authenticationBloc: _authenticationBloc),
          child: RegisterForm(pageController: _pageController),
        ),
      ],
    );
  }
}