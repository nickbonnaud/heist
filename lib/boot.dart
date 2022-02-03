import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/routing/app_router.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/themes/main_theme.dart';

class Boot extends StatelessWidget {
  final AppRouter _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MainTheme.themeData(context: context),
        initialRoute: Routes.app,
        title: Constants.appName,
        onGenerateRoute: (settings) => _router.goTo(context: context, settings: settings),
        localizationsDelegates: [
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
      )
    );
  }
}