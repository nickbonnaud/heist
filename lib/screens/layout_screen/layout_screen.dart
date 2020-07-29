import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/screens/home_screen/home_screen.dart';

import 'bloc/side_menu_bloc.dart';
import 'widgets/side_drawer.dart';

class LayoutScreen extends StatelessWidget {

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
}