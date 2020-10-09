import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/splash_screen/splash_screen.dart';

import 'splash_screen/bloc/splash_screen_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider<SplashScreenBloc>(
      create: (_) => SplashScreenBloc(bootBloc: BlocProvider.of<BootBloc>(context)),
      child: SplashScreen(),
    );
  }
}