import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/status.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './widgets/title_text.dart';

class SetupPaymentAccountCard extends StatelessWidget {

  const SetupPaymentAccountCard({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const TitleText(text: "Let's add a Payment Method!"),
                  ElevatedButton(
                    key: const Key("addPaymentButtonKey"),
                    onPressed: () => _connectButtonPressed(context: context),
                    child: const ButtonText(text: 'Connect')
                  ),
                  Text(
                    "${Constants.appName} uses a secure 3rd party service to create your payment account.", 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimarySubdued,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ),
            Row(
              children: [
                SizedBox(width: .1.sw),
                Expanded(
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        key: const Key("submitPaymentMethdKey"),
                        onPressed: _isNextButtonEnabled(state: state) ? () => _nextButtonPressed(context) : null,
                        child: const ButtonText(text: 'Next')
                      );
                    },
                  )
                ),
                SizedBox(width: .1.sw)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _connectButtonPressed({required BuildContext context}) {
    Status status = const Status(name: "pending", code: 120);
    Customer updatedCustomer = BlocProvider.of<CustomerBloc>(context).state.customer!.update(status: status);
    BlocProvider.of<CustomerBloc>(context).add(CustomerUpdated(customer: updatedCustomer));
  }

  bool _isNextButtonEnabled({required CustomerState state}) {
    return state.customer!.status.code == 120 || state.customer!.status.code == 200;
  }

  void _nextButtonPressed(BuildContext context) {
    BlocProvider.of<ProfileSetupScreenBloc>(context).add(const SectionCompleted(section: Section.paymentAccount));
  }
}