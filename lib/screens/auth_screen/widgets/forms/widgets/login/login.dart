import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'widgets/login_form/bloc/login_bloc.dart';
import 'widgets/login_form/login_form.dart';
import 'widgets/welcome_label.dart';

class Login extends StatelessWidget {
  final CustomerRepository _customerRepository;
  final PageController _pageController;

  Login({@required CustomerRepository customerRepository, @required PageController pageController})
    : assert(customerRepository != null && pageController != null),
      _customerRepository = customerRepository,
      _pageController = pageController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        WelcomeLabel(),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(customerRepository: _customerRepository),
          child: LoginForm(pageController: _pageController),
        )
      ],
    );
  }
}