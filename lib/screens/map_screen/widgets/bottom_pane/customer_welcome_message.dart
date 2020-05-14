import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class CustomerWelcomeMessage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          return state is SignedIn
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