import 'package:flutter/material.dart';

import 'widgets/nearby_businesses_map/nearby_businesses_map.dart';
import 'widgets/peek_sheet/peek_sheet.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NearbyBusinessesMap(),
          PeekSheet()
        ],
      ),
    );
  }
}