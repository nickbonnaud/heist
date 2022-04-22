import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/account_repository.dart';

import 'bloc/tip_form_bloc.dart';
import 'widgets/tip_form.dart';

class TipScreen extends StatelessWidget {

  const TipScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const BottomModalAppBar(),
      body: BlocProvider<TipFormBloc>(
        create: (BuildContext context) => TipFormBloc(
          accountRepository: RepositoryProvider.of<AccountRepository>(context),
          customerBloc: BlocProvider.of<CustomerBloc>(context),
        ),
        child: const TipForm(),
      )
    );
  }
}