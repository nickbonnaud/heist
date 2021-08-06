import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/global_colors.dart';

class SettingsList extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(height: SizeConfig.getHeight(2)),
        ListTile(
          key: Key("profileTileKey"),
          leading: Icon(
            Icons.person, 
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Profile', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => Navigator.of(context).pushNamed(Routes.profile)
        ),
        ListTile(
          key: Key("emailTileKey"),
          leading: Icon(
            Icons.email,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Email', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => Navigator.of(context).pushNamed(Routes.email)
        ),
        ListTile(
          key: Key("passwordTileKey"),
          leading: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Password', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => Navigator.of(context).pushNamed(Routes.password)
        ),
        ListTile(
          key: Key("paymentTileKey"),
          leading: Icon(
            Icons.payment,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Payment Method', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => print('show payment screen'),
        ),
        ListTile(
          key: Key("tipTileKey"),
          leading: Icon(
            Icons.thumb_up,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Tip Settings', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => Navigator.of(context).pushNamed(Routes.tips)
        ),
        SizedBox(height: SizeConfig.getHeight(10))
      ],
    );
  }
}