import 'dart:async';

import 'package:flare_flutter/flare_controls.dart';

class TakeoffControl extends FlareControls {
  final StreamController<String> _controller = StreamController<String>.broadcast();

  Stream get animationCompleted => _controller.stream;

  void dispose() => _controller.close();
  
  @override
  void onCompleted(String name) {
    _controller.sink.add(name);
    super.onCompleted(name);
  }
}