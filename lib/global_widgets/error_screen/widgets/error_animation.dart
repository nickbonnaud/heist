import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ErrorAnimation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: FlareActor(
        'assets/error.flr',
        animation: 'main',
        artboard: 'error',
      ),
    );
  }
}