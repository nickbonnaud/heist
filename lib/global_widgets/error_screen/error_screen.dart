import 'package:flutter/material.dart';

import 'widgets/error_animation.dart';
import 'widgets/error_card.dart';

class ErrorScreen extends StatelessWidget {
  final String _body;
  final String?  _buttonText;
  final VoidCallback? _onButtonPressed;

  const ErrorScreen({required String body, String? buttonText, VoidCallback? onButtonPressed, Key? key})
    : _body = body,
      _buttonText = buttonText,
      _onButtonPressed = onButtonPressed,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const ErrorAnimation(),
        Expanded(
          child: ErrorCard(body: _body, buttonText: _buttonText, onButtonPressed: _onButtonPressed)
        )
      ],
    );
  }
}