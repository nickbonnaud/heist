import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';

import 'widgets/login_form/bloc/login_bloc.dart';
import 'widgets/login_form/login_form.dart';
import 'widgets/welcome_label.dart';

class Login extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;
  final PageController _pageController;
  final PermissionsBloc _permissionsBloc;

  Login({
    required AuthenticationRepository authenticationRepository,
    required AuthenticationBloc authenticationBloc,
    required PageController pageController,
    required PermissionsBloc permissionsBloc
  })
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      _pageController = pageController,
      _permissionsBloc = permissionsBloc;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WelcomeLabel(),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(authenticationRepository: _authenticationRepository, authenticationBloc: _authenticationBloc),
          child: LoginForm(
            pageController: _pageController,
            permissionsBloc: _permissionsBloc,
          ),
        ),
      ],
    );
  }
}