import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/themes/global_colors.dart';

class MessageBubbleText extends StatelessWidget {
  final String _message;
  final bool _fromAdmin;

  const MessageBubbleText({required String message, bool fromAdmin: false})
    : _message = message,
      _fromAdmin = fromAdmin;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _message,
      style: TextStyle(
        color: _fromAdmin
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onCallToAction,
        fontSize: 16.sp
      ),
    );
  }
}