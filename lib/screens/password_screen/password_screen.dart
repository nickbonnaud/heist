import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/screens/password_screen/widgets/password_form.dart';

import 'bloc/password_form_bloc.dart';

class PasswordScreen extends StatelessWidget {
  final CustomerRepository _customerRepository = CustomerRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          return BlocProvider<PasswordFormBloc>(
            create: (BuildContext context) => PasswordFormBloc(customerRepository: _customerRepository, customerBloc: BlocProvider.of<CustomerBloc>(context)),
            child: PasswordForm(customer: state is SignedIn ? state.customer : null)
          );
        }
      ),
    );
  }
}