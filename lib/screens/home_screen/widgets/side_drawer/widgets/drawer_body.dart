import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/screens/transaction_business_picker_screen/bloc/transaction_business_picker_bloc.dart';
import 'package:heist/screens/transaction_picker_screen/models/transaction_picker_args.dart';

import 'widgets/drawer_item.dart';

class DrawerBody extends StatelessWidget {

  const DrawerBody({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 65.h),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: 40.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image.asset(
                'assets/logo.png',
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          SizedBox(height: 80.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _claimBillDrawerItem(),
              DrawerItem(
                key: const Key("transactionsDrawerItemKey"),
                onPressed: () => Navigator.of(context).pushNamed(Routes.transactions),
                text: 'Transactions',
                icon: Icon(
                  Icons.receipt, 
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),
              DrawerItem(
                key: const Key("refundsDrawerItemKey"),
                onPressed: () => Navigator.of(context).pushNamed(Routes.refunds), 
                text: 'Refunds',
                icon: Icon(
                  Icons.receipt_long,
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),
              DrawerItem(
                key: const Key("settingsDrawerItemKey"),
                onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
                text: 'Settings',
                icon: Icon(
                  Icons.settings, 
                  color: Theme.of(context).colorScheme.secondary
                )
              ),
              DrawerItem(
                key: const Key("tutorialDrawerItemKey"),
                onPressed: () => Navigator.of(context).pushNamed(Routes.tutorial),
                text: 'Tutorial', 
                icon: Icon(
                  Icons.lightbulb,
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),
              DrawerItem(
                key: const Key("helpDrawerItemKey"),
                onPressed: () => Navigator.of(context).pushNamed(Routes.helpTickets),
                text: 'Help',
                icon: Icon(
                  Icons.contact_support,
                  color: Theme.of(context).colorScheme.secondary
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _claimBillDrawerItem() {
    return BlocBuilder<TransactionBusinessPickerBloc, TransactionBusinessPickerState>(
      buildWhen: (previous, current) => previous.availableBusinesses.length != current.availableBusinesses.length,
      builder: (context, state) {
        if (state.availableBusinesses.isEmpty) return Container();

        return DrawerItem(
          key: const Key("transactionBusinessPickerItemKey"),
          onPressed: () => state.availableBusinesses.length == 1
            ? Navigator.of(context).pushNamed(Routes.transactionPicker, arguments: TransactionPickerArgs(business: state.availableBusinesses.first, fromSettings: true))
            : Navigator.of(context).pushNamed(Routes.transactionBusinessPicker, arguments: state.availableBusinesses),
          text: "Claim Bill",
          icon: Icon(
            Icons.storefront_rounded,
            color: Theme.of(context).colorScheme.secondary
          )
        ); 
      }
    );
  }
}