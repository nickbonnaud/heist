import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/account_repository.dart';

import 'bloc/tip_form_bloc.dart';
import 'widgets/tip_form.dart';

class TipScreen extends StatelessWidget {
  final AccountRepository _accountRepository = AccountRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: BottomModalAppBar(),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          return BlocProvider<TipFormBloc>(
            create: (BuildContext context) => TipFormBloc(accountRepository: _accountRepository, customerBloc: BlocProvider.of<CustomerBloc>(context)),
            child: TipForm(customer: state is SignedIn ? state.customer : null),
          );
        },
      ),
    );
  }
}