import 'package:flutter/material.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

import '../page_offset_notifier.dart';
import 'widgets/login/login.dart';
import 'widgets/register/register.dart';

class Forms extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final PageController _pageController;
  final bool _permissionsReady;
  final bool _customerOnboarded;


  Forms({
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
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        if (notifier.page.round() == 0) {
          return Login(
            authenticationRepository: _authenticationRepository,
            pageController: _pageController,
            permissionsReady: _permissionsReady,
            customerOnboarded: _customerOnboarded
          );
        } else {
          return Register(authenticationRepository: _authenticationRepository, pageController: _pageController);
        }
      }
    );
  }
}