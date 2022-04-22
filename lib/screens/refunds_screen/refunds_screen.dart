import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/refunds_screen_bloc.dart';
import 'widgets/refunds_screen_body.dart';

class RefundsScreen extends StatelessWidget {

  const RefundsScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: BlocProvider<RefundsScreenBloc>(
        create: (BuildContext context) => RefundsScreenBloc(
          refundRepository: RepositoryProvider.of<RefundRepository>(context)
        )..add(const FetchAllRefunds()),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          body: const RefundsScreenBody(),
        ),
      ),
    );
  }
}