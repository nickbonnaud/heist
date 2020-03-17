import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/screens/onboard_screen/helpers/onboard_screen_checker.dart';

import 'permission_screen/helpers/permission_screen_checker.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // PermissionScreenChecker().showPermissionScreen(context: context);
    OnboardScreenChecker().showOnboardScreen(context: context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: PlatformText('Hello World'),
      ),
    );
  }
}