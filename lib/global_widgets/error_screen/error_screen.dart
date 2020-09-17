import 'package:flutter/material.dart';

import 'widgets/error_animation.dart';
import 'widgets/error_card.dart';

class ErrorScreen extends StatelessWidget {
  final String _body;
  final String  _buttonText;
  final Function _onButtonPressed;

  ErrorScreen({@required String body, String buttonText, Function onButtonPressed})
    : assert(body != null),
      _body = body,
      _buttonText = buttonText,
      _onButtonPressed = onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ErrorAnimation(),
        Expanded(
          child: ErrorCard(body: _body, buttonText: _buttonText, onButtonPressed: _onButtonPressed)
        )
      ],
    );
  }
}