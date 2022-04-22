import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/account_repository.dart';

import 'bloc/setup_tip_card_bloc.dart';
import 'widgets/setup_tip_body.dart';

class SetupTipCard extends StatelessWidget {

  const SetupTipCard({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BlocProvider<SetupTipCardBloc>(
        create: (_) => SetupTipCardBloc(
          accountRepository: RepositoryProvider.of<AccountRepository>(context), 
          customerBloc: BlocProvider.of<CustomerBloc>(context)
        ),
        child: const SetupTipBody(),
      ),
    );
  }
}