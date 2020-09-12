import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/screens/permission_screen/widgets/permission_cards/widgets/success_card.dart';
import 'package:heist/screens/permission_screen/widgets/permissions_animation/permissions_animation.dart';

import 'widgets/permission_cards/permission_cards.dart';


class PermissionsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff6f4),
      body: _constructBody(context: context)
    );
  }

  Widget _constructBody({@required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PermissionsAnimation(),
        Expanded(
          child: Stack(
            children: [
              SuccessCard(),
              PermissionCards(),
            ],
          )
        )
      ],
    );
  }
}