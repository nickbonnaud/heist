import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/screens/password_screen/widgets/password_form.dart';

import 'bloc/password_form_bloc.dart';

class PasswordScreen extends StatelessWidget {

  const PasswordScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const BottomModalAppBar(),
      body: BlocProvider<PasswordFormBloc>(
        create: (BuildContext context) => PasswordFormBloc(
          customerRepository: RepositoryProvider.of<CustomerRepository>(context),
          authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          customerBloc: BlocProvider.of<CustomerBloc>(context)
        ),
        child: const PasswordForm()
      )
    );
  }
}