import 'package:flutter/material.dart';
import 'widgets/bottom_pane/bottom_pane.dart';
import 'widgets/top_pane/top_pane.dart';

class MapScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopPane(),
        BottomPane()
      ],
    );
  }
}