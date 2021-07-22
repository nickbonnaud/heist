import 'package:flutter/material.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:provider/provider.dart';

import '../page_offset_notifier.dart';
import 'widgets/login/login.dart';
import 'widgets/register/register.dart';

class Forms extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;
  final PageController _pageController;
  final PermissionsBloc _permissionsBloc;


  Forms({
    required AuthenticationRepository authenticationRepository,
    required AuthenticationBloc authenticationBloc,
    required PageController pageController,
    required PermissionsBloc permissionsBloc,
  })
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      _pageController = pageController,
      _permissionsBloc = permissionsBloc;

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        if (notifier.page.round() == 0) {
          return Login(
            authenticationRepository: _authenticationRepository,
            authenticationBloc: _authenticationBloc,
            pageController: _pageController,
            permissionsBloc: _permissionsBloc
          );
        } else {
          return Register(
            authenticationRepository: _authenticationRepository,
            authenticationBloc: _authenticationBloc,
            pageController: _pageController
          );
        }
      }
    );
  }
}