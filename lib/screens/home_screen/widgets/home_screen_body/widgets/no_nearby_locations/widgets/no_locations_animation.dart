import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class NoLocationsAnimation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff501a75),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: FlareActor(
        'assets/theme.flr',
        animation: 'main',
        artboard: 'no_locations',
      ),
    );
  }
}