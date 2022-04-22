import 'package:flutter/material.dart';

import 'widgets/permission_cards/permission_cards.dart';
import 'widgets/permission_cards/widgets/success_card.dart';
import 'widgets/permissions_animation/permissions_animation.dart';


class PermissionsScreen extends StatelessWidget {

  const PermissionsScreen({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff6f4),
      body: _constructBody(context: context)
    );
  }

  Widget _constructBody({required BuildContext context}) {
    return Column(
      key: const Key("permissionsScreenKey"),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const PermissionsAnimation(),
        Expanded(
          child: Stack(
            children: const [
              SuccessCard(),
              PermissionCards(),
            ],
          )
        )
      ],
    );
  }
}