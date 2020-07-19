import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/home_screen/home_screen.dart';
import 'package:heist/screens/map_screen/map_screen.dart';

import 'bloc/side_menu_bloc.dart';
import 'widgets/side_drawer.dart';

class LayoutScreen extends StatelessWidget {

  // new

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<SideMenuBloc>(
        create: (_) => SideMenuBloc(),
        child: SideDrawer(homeScreen: HomeScreen()),
      )
    );
  }
  
  
  // Old

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: BlocProvider<SideMenuBloc>(
  //       create: (BuildContext context) => SideMenuBloc(),
  //       child: SideDrawer(homeScreen: MapScreen())
  //     ),
  //   );
  // }
}