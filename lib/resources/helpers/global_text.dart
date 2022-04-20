import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/themes/global_colors.dart';

class ScreenTitle extends StatelessWidget {
  final String _title;
  final Color? _color;

  const ScreenTitle({required String title, Color? color, Key? key})
    : _title = title,
      _color = color,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color ?? Theme.of(context).colorScheme.onPrimary,
        fontSize: 40.sp
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final String _text;
  final Color? _color;

  const ButtonText({required String text, Color? color, Key? key})
    : _text = text,
      _color = color,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color ?? Theme.of(context).colorScheme.onSecondary,
        fontSize: 25.sp
      ),
    );
  }
}

class SnackbarText extends StatelessWidget {
  final String _text;

  const SnackbarText({required String text, Key? key})
    : _text = text,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 24.sp
      ),
    );
  }
}

class ActionText extends StatelessWidget {
  final String? _text;
  final Color? _color;

  const ActionText({String? text, Color? color, Key? key})
    : _text = text,
      _color = color,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return PlatformText(
      _text == null ? "Done" : _text!,
      style: TextStyle(
        color: _color ?? Theme.of(context).colorScheme.callToAction,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String _text;

  const AppBarTitle({required String text, Key? key})
    : _text = text,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28.sp
      ),
    );
  }
}