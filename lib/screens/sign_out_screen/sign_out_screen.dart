import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/screens/sign_out_screen/bloc/sign_out_bloc.dart';
import 'package:heist/screens/sign_out_screen/widgets/sign_out_body.dart';

class SignOutScreen extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationBloc _authenticationBloc;

  const SignOutScreen({required AuthenticationRepository authenticationRepository, required AuthenticationBloc authenticationBloc, Key? key})
    : _authenticationRepository = authenticationRepository,
      _authenticationBloc = authenticationBloc,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: BottomModalAppBar(context: context),
      body: BlocProvider<SignOutBloc>(
        create: (_) => SignOutBloc(
          authenticationRepository: _authenticationRepository,
          authenticationBloc: _authenticationBloc
        ),
        child: const SignOutBody(),
      ),
    );
  }
}