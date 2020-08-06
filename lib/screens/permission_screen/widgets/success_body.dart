import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class SuccessBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VeryBoldText2(text: 'Success!', context: context),
            SizedBox(height: SizeConfig.getHeight(6)),
            Image.asset(
              "assets/slide_4.png",
              fit: BoxFit.contain,
            ),
            SizedBox(height: SizeConfig.getHeight(6)),
            PlatformText('All your device permissions are set!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimarySubdued,
                fontSize: SizeConfig.getWidth(5),
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}