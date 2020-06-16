import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/home_screen/bloc/side_menu_bloc.dart';
import 'package:heist/screens/home_screen/widgets/side_drawer.dart';
import 'package:heist/screens/map_screen/map_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<SideMenuBloc>(
        create: (BuildContext context) => SideMenuBloc(),
        child: SideDrawer(homeScreen: MapScreen())
      ),
    );
  }
}