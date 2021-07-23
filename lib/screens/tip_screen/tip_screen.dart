import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/tip_form_bloc.dart';
import 'widgets/tip_form.dart';

class TipScreen extends StatelessWidget {
  final AccountRepository _accountRepository;
  final CustomerBloc _customerBloc;

  TipScreen({required AccountRepository accountRepository, required CustomerBloc customerBloc})
    : _accountRepository = accountRepository,
      _customerBloc = customerBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BottomModalAppBar(context: context, backgroundColor: Theme.of(context).colorScheme.topAppBar),
      body: BlocProvider<TipFormBloc>(
        create: (BuildContext context) => TipFormBloc(
          accountRepository: _accountRepository,
          customerBloc: _customerBloc,
        ),
        child: TipForm(
          account: _customerBloc.state.customer!.account,
        ),
      )
    );
  }
}