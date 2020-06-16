import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/screens/password_screen/widgets/password_form.dart';

import 'bloc/password_form_bloc.dart';

class PasswordScreen extends StatelessWidget {
  final CustomerRepository _customerRepository = CustomerRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: BottomModalAppBar(),
      body: BlocProvider<PasswordFormBloc>(
        create: (BuildContext context) => PasswordFormBloc(customerRepository: _customerRepository, authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: PasswordForm(customer: BlocProvider.of<AuthenticationBloc>(context).customer)
      )
    );
  }
}