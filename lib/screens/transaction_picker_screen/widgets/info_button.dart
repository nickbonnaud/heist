import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: PlatformIconButton(
        key: Key("infoButtonKey"),
        icon: Icon(
          Icons.info,
          size: 40.sp,
          color: Theme.of(context).colorScheme.callToAction
        ),
        onPressed: () => _showInfoDialog(context),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
          key: Key("transactionPickerInfoDialog"),
          title: PlatformText("Why is the receipt blurry?"),
          content: PlatformText("The blurred receipt is a default image. ${Constants.appName} only shows 1 unique item per receipt to allow you to identify your bill."),
          actions: [
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