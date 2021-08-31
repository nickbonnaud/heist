import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/screens/transaction_business_picker_screen/bloc/transaction_business_picker_bloc.dart';
import 'package:heist/screens/transaction_picker_screen/models/transaction_picker_args.dart';

import 'widgets/drawer_item.dart';

class DrawerBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 65.h),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(height: 40.h),
            Container(
              child: Align(
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
            ),
            SizedBox(height: 80.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<TransactionBusinessPickerBloc, TransactionBusinessPickerState>(
                  builder: (context, state) {
                    if (state.availableBusinesses.length == 0) return Container();

                    return DrawerItem(
                      key: Key("transactionBusinessPickerItemKey"),
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
                ),
                DrawerItem(
                  key: Key("transactionsDrawerItemKey"),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.transactions),
                  text: 'Transactions',
                  icon: Icon(
                    Icons.receipt, 
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                DrawerItem(
                  key: Key("refundsDrawerItemKey"),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.refunds), 
                  text: 'Refunds',
                  icon: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                DrawerItem(
                  key: Key("settingsDrawerItemKey"),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
                  text: 'Settings',
                  icon: Icon(
                    Icons.settings, 
                    color: Theme.of(context).colorScheme.secondary
                  )
                ),
                DrawerItem(
                  key: Key("tutorialDrawerItemKey"),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.tutorial),
                  text: 'Tutorial', 
                  icon: Icon(
                    Icons.lightbulb,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                DrawerItem(
                  key: Key("helpDrawerItemKey"),
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
      ),
    );
  }
}