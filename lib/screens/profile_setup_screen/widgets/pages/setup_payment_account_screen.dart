import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/status.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';

class SetupPaymentAccountScreen extends StatefulWidget {
  final AnimationController _controller;

  SetupPaymentAccountScreen({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;

  @override
  State<SetupPaymentAccountScreen> createState() => _SetupPaymentAccountScreen();
}

class _SetupPaymentAccountScreen extends State<SetupPaymentAccountScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(height: SizeConfig.getHeight(15)),
              BoldText.veryBold(
                text: "Let's add your Payment Method!", 
                size: SizeConfig.getWidth(6),
                color: Colors.black
              ),
              SizedBox(height: SizeConfig.getHeight(10)),
              RaisedButton(
                color: Colors.blue,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () => _connectButtonPressed(),
                child: BoldText(text: 'Connect', size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              SizedBox(height: SizeConfig.getHeight(8)),
              BoldText(
                text: "${Constants.appName} uses a secure 3rd party service to create your payment account.", 
                size: SizeConfig.getWidth(4), 
                color: Colors.grey.shade600
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<CustomerBloc, CustomerState>(
                  builder: (context, state) {
                    return RaisedButton(
                      color: Colors.green,
                      disabledColor: Colors.green.shade100,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: _isNextButtonEnabled(state is SignedIn ? state.customer : null) ? () => _nextButtonPressed(context) : null,
                      child: BoldText(text: 'Next', size: SizeConfig.getWidth(6), color: Colors.white)
                    );
                  },
                )
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget._controller.removeStatusListener(_animationListener);
    super.dispose();
  }

  void _connectButtonPressed() {
    Customer customer =  BlocProvider.of<CustomerBloc>(context).customer;
    Status status = new Status(name: "pending", code: 120);
    customer = customer.update(status: status);
    BlocProvider.of<CustomerBloc>(context).add(UpdateCustomer(customer: customer));
  }

  bool _isNextButtonEnabled(Customer customer) {
    return customer.status.code == 120 || customer.status.code == 200;
  }

  void _nextButtonPressed(BuildContext context) {
    widget._controller.addStatusListener(_animationListener);
    widget._controller.forward();
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.paymentAccount));
    }
  }
}