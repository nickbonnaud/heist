import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';

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