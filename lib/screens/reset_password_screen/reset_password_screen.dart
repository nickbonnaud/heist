import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/reset_password_args.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/screens/reset_password_screen/bloc/reset_password_form_bloc.dart';

import 'widgets/reset_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final ResetPasswordArgs _resetPasswordArgs;

  const ResetPasswordScreen({required AuthenticationRepository authenticationRepository, required ResetPasswordArgs resetPasswordArgs})
    : _authenticationRepository = authenticationRepository,
      _resetPasswordArgs = resetPasswordArgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<ResetPasswordFormBloc>(
        create: (_) => ResetPasswordFormBloc(authenticationRepository: _authenticationRepository, email: _resetPasswordArgs.email),
        child: ResetPasswordForm(),
      ),
    );
  }
}