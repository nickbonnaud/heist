import 'package:flutter/material.dart';

import 'widgets/no_locations_animation.dart';
import 'widgets/no_locations_card.dart';

class NoNearbyLocations extends StatelessWidget {

  const NoNearbyLocations({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        NoLocationsAnimation(),
        Expanded(
          child: NoLocationsCard()
        )
      ],
    );
  }
}