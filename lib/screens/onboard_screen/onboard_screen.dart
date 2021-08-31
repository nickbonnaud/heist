import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

import 'bloc/onboard_bloc.dart';
import 'widgets/onboard_body.dart';

class OnboardScreen extends StatelessWidget {
  final PermissionsBloc _permissionsBloc;
  final CustomerBloc _customerBloc;

  OnboardScreen({
    required PermissionsBloc permissionsBloc,
    required CustomerBloc customerBloc,
  })
    : _permissionsBloc = permissionsBloc,
      _customerBloc = customerBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<OnboardBloc>(
        create: (_) => OnboardBloc(
          customerStatus: _customerBloc.customer!.status,
          numberValidPermissions: _permissionsBloc.numberValidPermissions
        ),
        child: OnboardBody(
          permissionsBloc: _permissionsBloc,
          customerStatus: _customerBloc.customer!.status,
        ),
      ),
    );
  }
}