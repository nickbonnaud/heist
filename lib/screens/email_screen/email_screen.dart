import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/customer_repository.dart';

import 'bloc/email_form_bloc.dart';
import 'widgets/email_form.dart';

class EmailScreen extends StatelessWidget {

  const EmailScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const BottomModalAppBar(),
      body: BlocProvider<EmailFormBloc>(
        create: (_) => EmailFormBloc(
          customerRepository: RepositoryProvider.of<CustomerRepository>(context),
          customerBloc: BlocProvider.of<CustomerBloc>(context)
        ),
        child: const EmailForm(),
      )
    );
  }
}