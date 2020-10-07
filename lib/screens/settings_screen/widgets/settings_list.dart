import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/email_screen/email_screen.dart';
import 'package:heist/screens/password_screen/password_screen.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';
import 'package:heist/screens/tip_screen/tip_screen.dart';
import 'package:heist/themes/global_colors.dart';

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(height: SizeConfig.getHeight(2)),
        ListTile(
          leading: Icon(
            Icons.person, 
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Profile', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => _showModal(context: context, screen: ProfileScreen())
        ),
        ListTile(
          leading: Icon(
            Icons.email,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Email', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => _showModal(context: context, screen: EmailScreen())
        ),
        ListTile(
          leading: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Password', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => _showModal(context: context, screen: PasswordScreen())
        ),
        ListTile(
          leading: Icon(
            Icons.payment,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Payment Method', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => print('show payment screen'),
        ),
        ListTile(
          leading: Icon(
            Icons.thumb_up,
            color: Theme.of(context).colorScheme.secondary,
            size: SizeConfig.getWidth(8)
          ),
          title: Text1(text: 'Change Tip Settings', context: context, color: Theme.of(context).colorScheme.callToAction),
          onTap: () => _showModal(context: context, screen: TipScreen())
        ),
        SizedBox(height: SizeConfig.getHeight(10))
      ],
    );
  }

  void _showModal({@required BuildContext context, @required Widget screen}) {
    BlocProvider.of<DefaultAppBarBloc>(context).add(Rotate());
    showPlatformModalSheet(
      context: context,
      builder: (_) => screen
    ).then((_) {
      BlocProvider.of<DefaultAppBarBloc>(context).add(Reset());
    });
  }
}