import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';

class InfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: PlatformIconButton(
        icon: Icon(context.platformIcons.info, size: SizeConfig.getWidth(6), color: Colors.black),
        onPressed: () => _showInfoDialog(context),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
          title: PlatformText("Why is the receipt blurry?"),
          content: PlatformText("The blurred receipt is a default image. ${Constants.appName} only shows 1 unique item per receipt to allow you to identify your bill."),
          actions: <Widget>[
            PlatformDialogAction(
              child: PlatformText('OK'), 
              onPressed: () {
                Navigator.pop(context);
              } 
            )
          ],
        ),
    );
  }
}