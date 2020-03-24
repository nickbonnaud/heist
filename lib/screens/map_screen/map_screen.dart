import 'package:flutter/material.dart';
import 'widgets/bottom_pane.dart';
import 'widgets/top_pane/top_pane.dart';

class MapScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TopPane(),
        BottomPane()
      ],
    );
  }
}