import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'bloc/register_bloc.dart';
import 'widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;

  RegisterScreen({Key key, @required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill
          )
        ),
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(customerRepository: _customerRepository),
          child: RegisterForm(customerRepository: _customerRepository),
        ),
      ),
    );
  }
}