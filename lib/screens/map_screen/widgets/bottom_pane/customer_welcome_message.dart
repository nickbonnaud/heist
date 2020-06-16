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
            ? _createWelcomeMessage("Welcome ${state.customer.profile.firstName}!")
            : _createWelcomeMessage("Welcome Back!");
        }
      ),
    );
  }

  Widget _createWelcomeMessage(String message) {
    return BoldText.veryBold(text: message, size: SizeConfig.getWidth(5), color: Colors.black);
  }
}