import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ErrorAnimation extends StatelessWidget {

  const ErrorAnimation({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: const FlareActor(
        'assets/error.flr',
        animation: 'main',
        artboard: 'error',
      ),
    );
  }
}