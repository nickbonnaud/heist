import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class SuccessCard extends StatelessWidget {

  final String successText =
  'All permissions are ready. Start using ${Constants.appName} now!';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), 
            spreadRadius: 1.0,
            blurRadius: 5,
            offset: Offset(0, -5)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: SizeConfig.getHeight(2)),
              VeryBoldText2(text: 'Success', context: context),
              SizedBox(height: SizeConfig.getHeight(6)),
              PlatformText('Permissions are a Go!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: SizeConfig.getWidth(6),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline
                ),
              ),
              SizedBox(height: SizeConfig.getHeight(2)),
              PlatformText(successText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimarySubdued,
                    fontSize: SizeConfig.getWidth(6),
                    fontWeight: FontWeight.bold
                  ),
              )
            ],
          ),
          Container()
        ],
      ),
    );
  }
}