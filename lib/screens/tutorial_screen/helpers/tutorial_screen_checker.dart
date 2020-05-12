import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/repositories/tutorial_repository.dart';

import '../tutorial_screen.dart';

class TutorialScreenChecker {

  void showTutorialScreen({@required BuildContext context}) {
    _showTutorial().then((bool showTutorial) {
      if (showTutorial || showTutorial == null) {
        _showTutorialModal(context: context);
      }
    });
  }

  Future<bool> _showTutorial() async {
    return TutorialRepository().showTutorial();
  }

  void _showTutorialModal({@required BuildContext context}) {
    showPlatformModalSheet(
      context: context,
      builder: (_) => TutorialScreen()
    );
  }
}