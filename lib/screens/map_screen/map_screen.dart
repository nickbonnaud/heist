import 'package:flutter/material.dart';
import 'widgets/bottom_pane.dart';
import 'widgets/top_pane/top_pane.dart';

class MapScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TopPane(),
        BottomPane()
      ],
    ),
    );
  }
}