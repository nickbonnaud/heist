import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/routing/app_router.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/main_theme.dart';

class Boot extends StatelessWidget {
  final AppRouter _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return _app(context: context);
  }

  MaterialApp _app({required BuildContext context}) {
    return MaterialApp(
      theme: MainTheme.themeData(context: context),
      initialRoute: Routes.app,
      title: Constants.appName,
      onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
      localizationsDelegates: [
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
    );
    
    // return Theme(
    //   data: MainTheme.themeData(context: context),
    //   child: PlatformProvider(
    //     builder: (context) {
    //       return PlatformApp(
    //         initialRoute: Routes.app,
    //         title: Constants.appName,
    //         onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
    //         localizationsDelegates: [
    //           DefaultWidgetsLocalizations.delegate,
    //           DefaultCupertinoLocalizations.delegate,
    //           DefaultMaterialLocalizations.delegate,
    //         ],
    //       );
    //     }
    //   )
    // );
  }
}