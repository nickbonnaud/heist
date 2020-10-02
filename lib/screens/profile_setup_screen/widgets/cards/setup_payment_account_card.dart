import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/status.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

class SetupPaymentAccountCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  VeryBoldText4(
                    text: "Let's add your Payment Method!", 
                    context: context,
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () => _connectButtonPressed(context: context),
                    child: BoldText3(text: 'Connect', context: context, color: Theme.of(context).colorScheme.onSecondary)
                  ),
                  Text2(
                    text: "${Constants.appName} uses a secure 3rd party service to create your payment account.", 
                    context: context, 
                    color: Theme.of(context).colorScheme.onPrimarySubdued
                  ),
                ],
              )
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _isNextButtonEnabled(state) ? () => _nextButtonPressed(context) : null,
                        child: BoldText3(text: 'Next', context: context, color: Theme.of(context).colorScheme.onSecondary)
                      );
                    },
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _connectButtonPressed({@required BuildContext context}) {
    Customer customer = BlocProvider.of<AuthenticationBloc>(context).customer;
    Status status = Status(name: "pending", code: 120);
    Customer updatedCustomer = customer.update(status: status);
    BlocProvider.of<AuthenticationBloc>(context).add(CustomerUpdated(customer: updatedCustomer));
  }

  bool _isNextButtonEnabled(AuthenticationState state) {
    return state.customer.status.code == 120 || state.customer.status.code == 200;
  }

  void _nextButtonPressed(BuildContext context) {
    BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.paymentAccount));
  }
}