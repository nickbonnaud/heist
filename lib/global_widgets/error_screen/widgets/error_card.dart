import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class ErrorCard extends StatelessWidget {
  final String _body;
  final String _buttonText;
  final Function _onButtonPressed;

  ErrorCard({@required String body, String buttonText, Function onButtonPressed})
    : assert(body != null),
      _body = body,
      _buttonText = buttonText,
      _onButtonPressed = onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 20),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: SizeConfig.getHeight(2)),
              VeryBoldText2(text: "Malfunction!", context: context),
              SizedBox(height: SizeConfig.getHeight(6)),
              PlatformText(_body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: SizeConfig.getWidth(6),
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          _onButtonPressed != null
            ? Row(
                children: [
                  SizedBox(width: SizeConfig.getWidth(20)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onButtonPressed,
                      child: BoldText3(text: _buttonText, context: context, color: Theme.of(context).colorScheme.onSecondary),
                    )
                  ),
                  SizedBox(width: SizeConfig.getWidth(20)),
                ],
              )
            : Container()
        ],
      ),
    );
  }
}