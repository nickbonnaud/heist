import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

import 'bloc/onboard_bloc.dart';
import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {

  const OnboardScreen({Key? key})
    :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<OnboardBloc>(
        create: (_) => OnboardBloc(
          customerStatus: BlocProvider.of<CustomerBloc>(context).customer!.status,
          numberValidPermissions: BlocProvider.of<PermissionsBloc>(context).numberValidPermissions
        ),
        child: const SafeArea(
          child: OnboardBody()
        ),
      ),
    );
  }
}