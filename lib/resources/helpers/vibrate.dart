import 'package:flutter/services.dart';

class Vibrate {

  static void error() {
    HapticFeedback.vibrate();
  }

  static void success() {
    HapticFeedback.lightImpact();
  }
}