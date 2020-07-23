import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'widgets/register_form/bloc/register_bloc.dart';
import 'widgets/register_form/register_form.dart';
import 'widgets/welcome_label.dart';

class Register extends StatelessWidget {
  final CustomerRepository _customerRepository;
  final PageController _pageController;

  Register({@required CustomerRepository customerRepository, @required PageController pageController})
    : assert(customerRepository != null && pageController != null),
      _customerRepository = customerRepository,
      _pageController = pageController;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        WelcomeLabel(),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(customerRepository: _customerRepository),
          child: RegisterForm(pageController: _pageController),
        ),
      ],
    );
  }
}