import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/resources/helpers/animated_routes.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/home_screen/home_screen.dart';

class FetchingInitialDataScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocListener<BootBloc, BootState>(
      listener: (context, state) {
        if (state.isDataLoaded) {
          Navigator.of(context).pushReplacement(AnimatedRoutes.centralIn(HomeScreen()));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/slide_3.png",
            fit: BoxFit.contain,
            height: 350,
          ),
          BoldText(text: "Loading Data", size: 18, color: Colors.black)
        ],
      )
    );
  }
}