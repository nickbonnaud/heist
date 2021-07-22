import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/authentication_repository.dart';

import 'bloc/request_reset_form_bloc.dart';
import 'widgets/request_reset_password_form.dart';

class RequestResetPasswordScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const RequestResetPasswordScreen({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<RequestResetFormBloc>(
        create: (_) => RequestResetFormBloc(authenticationRepository: _authenticationRepository),
        child: RequestResetPasswordForm(),
      ),
    );
  }
}