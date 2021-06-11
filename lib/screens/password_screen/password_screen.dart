import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/screens/password_screen/widgets/password_form.dart';

import 'bloc/password_form_bloc.dart';

class PasswordScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;
  final AuthenticationRepository _authenticationRepository;
  final CustomerBloc _customerBloc;

  PasswordScreen({required CustomerRepository customerRepository, required AuthenticationRepository authenticationRepository, required CustomerBloc customerBloc})
    : _customerRepository = customerRepository,
      _authenticationRepository = authenticationRepository,
      _customerBloc = customerBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<PasswordFormBloc>(
        create: (BuildContext context) => PasswordFormBloc(
          customerRepository: _customerRepository,
          authenticationRepository: _authenticationRepository,
          customerBloc: _customerBloc
        ),
        child: PasswordForm(customer: _customerBloc.customer!)
      )
    );
  }
}