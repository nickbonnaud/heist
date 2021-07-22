import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/status.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

class SetupPaymentAccountCard extends StatelessWidget {
  final CustomerBloc _customerBloc;

  SetupPaymentAccountCard({required CustomerBloc customerBloc})
    : _customerBloc = customerBloc;

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
                  ElevatedButton(
                    key: Key("addPaymentButtonKey"),
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
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        key: Key("submitPaymentMethdKey"),
                        onPressed: _isNextButtonEnabled(state: state) ? () => _nextButtonPressed(context) : null,
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

  void _connectButtonPressed({required BuildContext context}) {
    Status status = Status(name: "pending", code: 120);
    Customer updatedCustomer = _customerBloc.state.customer!.update(status: status);
    _customerBloc.add(CustomerUpdated(customer: updatedCustomer));
  }

  bool _isNextButtonEnabled({required CustomerState state}) {
    return state.customer!.status.code == 120 || state.customer!.status.code == 200;
  }

  void _nextButtonPressed(BuildContext context) {
    BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.paymentAccount));
  }
}