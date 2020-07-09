import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'bloc/login_bloc.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;

  LoginScreen({Key key, @required CustomerRepository customerRepository})
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
        child: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(customerRepository: _customerRepository),
          child: LoginForm(customerRepository: _customerRepository)
        ),
      )
    );
  }
}