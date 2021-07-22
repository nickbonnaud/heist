import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'bloc/email_form_bloc.dart';
import 'widgets/email_form.dart';

class EmailScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;
  final CustomerBloc _customerBloc;

  const EmailScreen({required CustomerRepository customerRepository, required CustomerBloc customerBloc})
    : _customerRepository = customerRepository,
      _customerBloc = customerBloc;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<EmailFormBloc>(
        create: (_) => EmailFormBloc(customerRepository: _customerRepository, customerBloc: _customerBloc),
        child: EmailForm(customer: _customerBloc.customer!),
      )
    );
  }
}