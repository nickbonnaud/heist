import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/account_repository.dart';

import 'bloc/setup_tip_card_bloc.dart';
import 'widgets/setup_tip_body.dart';

class SetupTipCard extends StatelessWidget {
  final AccountRepository _accountRepository;
  final CustomerBloc _customerBloc;

  SetupTipCard({required AccountRepository accountRepository, required CustomerBloc customerBloc})
    : _accountRepository = accountRepository,
      _customerBloc = customerBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocProvider<SetupTipCardBloc>(
        create: (BuildContext context) => SetupTipCardBloc(
          accountRepository: _accountRepository, 
          customerBloc: _customerBloc
        ),
        child: SetupTipBody(accountIdentifier: _customerBloc.customer!.account.identifier,),
      ),
    );
  }
}