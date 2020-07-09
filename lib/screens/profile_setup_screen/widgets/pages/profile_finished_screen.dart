import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';

class ProfileFinishedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:  MainAxisAlignment.center,
      children: <Widget>[
        BoldText1(text: "Finished!", context: context),
        Image.asset(
          "assets/slide_3.png",
          fit: BoxFit.contain,
          height: 350,
        ),
        SizedBox(height: SizeConfig.getHeight(2)),
        BoldText3(text: "Profile Setup Complete!", context: context)
      ],
    );
  }
}