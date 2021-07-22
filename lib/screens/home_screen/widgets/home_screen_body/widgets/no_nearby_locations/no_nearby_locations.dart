import 'package:flutter/material.dart';

import 'widgets/no_locations_animation.dart';
import 'widgets/no_locations_card.dart';

class NoNearbyLocations extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NoLocationsAnimation(),
        Expanded(
          child: NoLocationsCard()
        )
      ],
    );
  }
}