import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'bloc/email_form_bloc.dart';
import 'widgets/email_form.dart';

class EmailScreen extends StatelessWidget {
  final CustomerRepository _customerRepository = CustomerRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          return BlocProvider<EmailFormBloc>(
            create: (BuildContext context) => EmailFormBloc(customerRepository: _customerRepository, customerBloc: BlocProvider.of<CustomerBloc>(context)),
            child: EmailForm(customer: state is SignedIn ? state.customer : null),
          );
        }
      ),
    );
  }
}