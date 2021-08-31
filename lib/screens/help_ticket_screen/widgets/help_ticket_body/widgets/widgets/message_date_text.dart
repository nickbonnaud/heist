import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/themes/global_colors.dart';

class MessageDateText extends StatelessWidget {
  final String _text;
  final bool _isDate;

  const MessageDateText({required String text, bool isDate: true})
    : _text = text,
      _isDate = isDate;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        color: _isDate
          ? Theme.of(context).colorScheme.onPrimarySubdued
          : Theme.of(context).colorScheme.onPrimaryDisabled,
        fontSize: 12.sp
      ),
    );
  }
}