import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class NoLocationsAnimation extends StatelessWidget {

  const NoLocationsAnimation({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff501a75),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: const FlareActor(
        'assets/theme.flr',
        animation: 'main',
        artboard: 'no_locations',
      ),
    );
  }
}