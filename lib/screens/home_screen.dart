import 'package:flutter/material.dart';
import 'package:heist/screens/map_screen/map_screen.dart';
import 'package:heist/screens/permission_screen/helpers/permission_screen_checker.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // PermissionScreenChecker().showPermissionScreen(context: context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: MapScreen()
    );
  }
}