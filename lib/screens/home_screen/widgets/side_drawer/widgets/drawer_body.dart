import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/routing/routes.dart';

import 'widgets/drawer_item.dart';

class DrawerBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.getHeight(8)),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(height: SizeConfig.getHeight(5)),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    'assets/logo.png',
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(10)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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