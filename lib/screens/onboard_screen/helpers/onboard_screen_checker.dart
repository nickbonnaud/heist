import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/repositories/onboard_repository.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';

class OnboardScreenChecker {

  void showOnboardScreen({@required BuildContext context}) {
    _showOnboardTutorial().then((bool showTutorial) {
      if (showTutorial || showTutorial == null) {
        _showTutorialModal(context: context);
      }
    });
  }

  Future<bool> _showOnboardTutorial() async {
    return OnboardRepository().showTutorial();
  }

  void _showTutorialModal({@required BuildContext context}) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => OnboardScreen()
    );
  }
}