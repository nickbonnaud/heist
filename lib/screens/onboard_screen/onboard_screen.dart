import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

import 'bloc/onboard_bloc.dart';
import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {
  final PermissionsBloc _permissionsBloc;
  final CustomerBloc _customerBloc;

  const OnboardScreen({
    required PermissionsBloc permissionsBloc,
    required CustomerBloc customerBloc,
    Key? key
  })
    : _permissionsBloc = permissionsBloc,
      _customerBloc = customerBloc,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<OnboardBloc>(
        create: (_) => OnboardBloc(
          customerStatus: _customerBloc.customer!.status,
          numberValidPermissions: _permissionsBloc.numberValidPermissions
        ),
        child: SafeArea(
          child: OnboardBody(
            permissionsBloc: _permissionsBloc,
            customerStatus: _customerBloc.customer!.status,
          )
        ),
      ),
    );
  }
}