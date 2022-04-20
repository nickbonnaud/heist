import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleText extends StatelessWidget {
  final String _text;

  const TitleText({required String text, Key? key})
    : _text = text,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 25.sp
      ),
    );
  }
}