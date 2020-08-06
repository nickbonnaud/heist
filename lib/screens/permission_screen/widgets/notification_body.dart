import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

import 'permission_buttons/bloc/permission_buttons_bloc.dart';
import 'permission_buttons/permission_buttons.dart';


class NotificationBody extends StatelessWidget {
  final PermissionButtons _permissionButtons;
  
  NotificationBody({@required PermissionButtons permissionButtons})
    : assert(permissionButtons != null),
      _permissionButtons = permissionButtons;

  final String notificationText = 
  'Please allow ${Constants.appName} to send you notifications.\n\n'
  'Notifications are required to receive and pay for transactions.';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        VeryBoldText2(text: 'Notications', context: context),
        SizedBox(height: SizeConfig.getHeight(6)),
        Image.asset(
          "assets/slide_2.png",
          fit: BoxFit.contain,
        ),
        SizedBox(height: SizeConfig.getHeight(6)),
        PlatformText(notificationText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimarySubdued,
            fontSize: SizeConfig.getWidth(5),
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(8)),
        BlocProvider<PermissionButtonsBloc>(
          create: (_) => PermissionButtonsBloc(),
          child: _permissionButtons
        )
      ],
    );
  }
}