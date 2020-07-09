import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class CustomerWelcomeMessage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return state.authenticated
            ? _createWelcomeMessage(message: "Welcome ${state.customer.profile.firstName}!", context: context)
            : _createWelcomeMessage(message: "Welcome Back!", context: context);
        }
      ),
    );
  }

  Widget _createWelcomeMessage({@required String message, @required BuildContext context}) {
    return BoldText2(text: message, context: context, color: Theme.of(context).colorScheme.primaryVariant);
  }
}