import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BottomPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PlatformText("Hello World")
    );
  }
  
}