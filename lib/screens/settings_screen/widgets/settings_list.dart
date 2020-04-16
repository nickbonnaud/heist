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

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        BoldText(text: 'Settings', size: SizeConfig.getWidth(9), color: Colors.black),
        SizedBox(height: SizeConfig.getHeight(5)),
        ListTile(
          leading: PlatformWidget(
            android: (_) => Icon(Icons.person),
            ios: (_) => Icon(IconData(
              0xF41A,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage
            )),
          ),
          title: NormalText(text: 'Change Profile', size: SizeConfig.getWidth(5), color: Colors.black54),
          onTap: () => _showModal(context: context, screen: ProfileScreen())
        ),
        ListTile(
          leading: PlatformWidget(
            android: (_) => Icon(Icons.email),
            ios: (_) => Icon(IconData(
              0xF474,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage
            )),
          ),
          title: NormalText(text: 'Change Email', size: SizeConfig.getWidth(5), color: Colors.black54),
          onTap: () => _showModal(context: context, screen: EmailScreen())
        ),
        ListTile(
          leading: PlatformWidget(
            android: (_) => Icon(Icons.lock),
            ios: (_) => Icon(IconData(
              0xF392,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage
            )),
          ),
          title: NormalText(text: 'Change Password', size: SizeConfig.getWidth(5), color: Colors.black54),
          onTap: () => _showModal(context: context, screen: PasswordScreen())
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: NormalText(text: 'Change Payment Method', size: SizeConfig.getWidth(5), color: Colors.black54),
          onTap: () => print('show payment screen'),
        ),
        ListTile(
          leading: PlatformWidget(
            android: (_) => Icon(Icons.thumb_up),
            ios: (_) => Icon(IconData(
              0xF388,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage
            )),
          ),
          title: NormalText(text: 'Change Tip Settings', size: SizeConfig.getWidth(5), color: Colors.black54),
          onTap: () => _showModal(context: context, screen: TipScreen())
        ),
        SizedBox(height: SizeConfig.getHeight(15))
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